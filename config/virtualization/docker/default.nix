# https://bbs.archlinux.org/viewtopic.php?pid=2132622#p2132622

{
  config,
  pkgs,
  lib,
  user,
  ...
}:

let
  enable = true;

  interface = "docker0";

  mark = {
    bridge = "0x10ca1";
    docker = "0xd0cca5e";
  };
in
{
  boot = lib.mkIf enable {
    kernel = {
      sysctl = {
        "net.ipv4.ip_nonlocal_bind" = 1;
        "net.ipv4.ip_forward" = 0;
      };
    };
    kernelModules = [ "ip_vs" ];

    blacklistedKernelModules = lib.mkIf (!config.virtualisation.docker.daemon.settings.iptables) [
      "ip_tables"
      "ip6_tables"
    ];
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "docker" ];
      };
    };
  };

  virtualisation = {
    docker = {
      enable = lib.mkDefault enable;
      enableOnBoot = lib.mkDefault enable;

      logDriver = "journald";

      rootless = {
        enable = false;
        setSocketVariable = config.virtualisation.docker.rootless.enable;
      };

      daemon = {
        settings = {
          iptables = !config.networking.nftables.enable;
          ip6tables = !config.networking.nftables.enable;

          dns = [
            "1.1.1.1"
            "1.0.0.1"
          ];

          bip = "10.200.0.1/24";
          default-address-pools = [
            {
              base = "10.201.0.0/16";
              size = 24;
            }

            {
              base = "10.202.0.0/16";
              size = 24;
            }
          ];
        };
      };
    };
  };

  networking = lib.mkIf enable {
    firewall = {
      trustedInterfaces = [ interface ];

      # https://unix.stackexchange.com/a/657786
      extraCommands = lib.mkIf (!config.networking.nftables.enable) ''
        iptables -N DOCKER-USER
        iptables -I DOCKER-USER 1 -j MARK --set-mark ${mark.docker}
        iptables -I DOCKER-USER 2 -m physdev --physdev-is-bridged -j MARK --set-mark ${mark.bridge}
        iptables -A FORWARD -m mark --mark ${mark.docker} -j MARK --set-mark 0
        iptables -A FORWARD -j ACCEPT
      '';
    };

    nftables = {
      tables = {
        docker-filter = {
          enable = false;

          name = "filter";
          family = "inet";

          content = ''
            chain forward {
                type filter hook forward priority 10; policy drop;
                meta mark ${mark.bridge} counter accept
                meta mark ${mark.docker} counter jump dockercase
            }

            chain dockercase {
                ${
                  (lib.lists.foldr (a: b: ''
                    ${a}
                    ${b}'') "")
                  (
                    builtins.map (iface: ''
                      # iif ${iface} ip saddr != 192.168.0.0/16 counter drop
                    '') (builtins.filter (iface: iface != interface) config.networking.firewall.trustedInterfaces)
                  )
                }
                counter accept
            }

            chain input {
                type filter hook input priority 0; policy drop;
                ct state related,established accept
                iif lo accept
                ${
                  (lib.lists.foldr (a: b: ''
                    ${a}
                    ${b}'') "")
                  (
                    builtins.map (iface: ''
                      # iif ${iface} icmp type echo-request accept
                      # iif ${iface} ip 192.168.0.0/16 tcp dport 22 accept
                      # iif ${iface} ip 192.168.0.0/16 tcp dport 80 accept
                      # iif ${iface} ip 192.168.0.0/16 tcp dport 443 accept
                    '') (builtins.filter (iface: iface != interface) config.networking.firewall.trustedInterfaces)
                  )
                }
            }

            chain output {
                type filter hook output priority 0; policy drop;
                ct state related,established accept
                oif lo accept
                udp dport { 53, 123 } accept
                tcp dport { 53, 80, 443 } accept
                icmp type echo-request accept
            }
          '';
        };

        docker-nat = {
          enable = false;

          name = "nat";
          family = "inet";

          content = ''
            chain prerouting {
                type nat hook prerouting priority dstnat;
                ${
                  (lib.lists.foldr (a: b: ''
                    ${a}
                    ${b}'') "")
                  (
                    lib.lists.flatten (
                      builtins.map
                        (
                          port:
                          builtins.map (ip: "tcp dport ${builtins.toString port} dnat ip to ${ip}") (
                            builtins.map (
                              x: builtins.elemAt (builtins.match "^(.+)/[[:digit:]]+$" x.base) 0
                            ) config.virtualisation.docker.daemon.settings.default-address-pools
                            ++ [
                              config.virtualisation.docker.daemon.settings.bip
                            ]
                          )
                        )
                        [
                          80
                          443
                        ]
                    )
                  )
                }
            }

            chain postrouting {
                type nat hook postrouting priority srcnat;
                masquerade
            }
          '';
        };
      };
    };
  };

  systemd = {
    packages = with pkgs; [
      (writeTextFile {
        name = "docker-netns";
        destination = "/etc/systemd/system/docker.service.d/netns.conf";

        text =
          if false then
            ''
              [Service]
              PrivateNetwork=yes
              PrivateMounts=No

              ExecStartPre=-${pkgs.util-linux}/bin/nsenter -t 1 -n -- ip link delete docker0

              ExecStartPre=-${pkgs.util-linux}/bin/nsenter -t 1 -n -- ip link add docker0 type veth peer name docker0_ns
              ExecStartPre=-${pkgs.runtimeShell} -c '${pkgs.util-linux}/bin/nsenter -t 1 -n -- ip link set docker0_ns netns "$$BASHPID" && true'
              ExecStartPre=-${pkgs.iproute2}/bin/ip link set docker0_ns name wifi

              ExecStartPre=-${pkgs.util-linux}/bin/nsenter -t 1 -n -- ip addr add ${config.virtualisation.docker.daemon.settings.bip} dev docker0
              ExecStartPre=-${pkgs.util-linux}/bin/nsenter -t 1 -n -- ip link set docker0 up

              ExecStartPre=-${pkgs.iproute2}/bin/ip addr add ${builtins.elemAt (builtins.match "^(.+)\\.[[:digit:]]+/[[:digit:]]+$" config.virtualisation.docker.daemon.settings.bip) 0}.100/24 dev wifi
              ${
                (lib.lists.foldr (a: b: ''
                  ${a}
                  ${b}
                '') "")
                (
                  builtins.map (
                    x: "# ExecStartPre=-${pkgs.iproute2}/bin/ip addr add ${x.base} dev wifi"
                  ) config.virtualisation.docker.daemon.settings.default-address-pools
                )
              }
              ExecStartPre=-${pkgs.iproute2}/bin/ip link set wifi up
              ExecStartPre=-${pkgs.iproute2}/bin/ip route add default via ${builtins.elemAt (builtins.match "^(.+)\\.[[:digit:]]+/[[:digit:]]+$" config.virtualisation.docker.daemon.settings.bip) 0}.1 dev wifi
            ''
          else
            ''
              [Service]
              PrivateNetwork=No
              PrivateMounts=No

              ExecStartPre=-${pkgs.runtimeShell} -c "true"
            '';
      })
    ];
  };

  environment = {
    systemPackages = with pkgs; [ docker-compose ];
  };
}
