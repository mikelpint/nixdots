# https://bbs.archlinux.org/viewtopic.php?pid=2132622#p2132622

{
  config,
  pkgs,
  lib,
  user,
  ...
}:

let
  # https://unix.stackexchange.com/a/657786
  mark = {
    bridge = "0x10ca1";
    docker = "0xd0cca5e";
  };

  extraCommands = ''
    # iptables -N DOCKER-USER
    iptables -I DOCKER-USER 1 -j MARK --set-mark ${mark.docker}
    iptables -I DOCKER-USER 2 -m physdev --physdev-is-bridged -j MARK --set-mark ${mark.bridge}
    iptables -A FORWARD -fm mark --mark ${mark.docker} -j MARK --set-mark 0
    iptables -A FORWARD -j ACCEPT
  '';
in
{
  boot =
    let
      noiptables = config.networking.nftables.enable # && !config.virtualisation.docker.daemon.settings.iptables
      ;
    in
    lib.mkIf config.virtualisation.docker.enable {
      kernel = {
        sysctl = {
          "net.ipv4.ip_nonlocal_bind" = 1;
          "net.ipv4.ip_forward" = 1;
          "net.ipv4.conf.all.forwarding" = 1;
          "net.ipv4.conf.default.forwarding" = 1;

          "net.ipv6.conf.all.forwarding" = 1;
          "net.ipv6.conf.default.forwarding" = 1;
          "net.bridge.bridge-nf-call-iptables" = if noiptables then 0 else null; # https://serverfault.com/a/964491
        };
      };

      kernelModules = [
        "ip_vs"
        "addrtype"
      ];

      blacklistedKernelModules = lib.mkIf noiptables [
        "ip_tables"
        "ip6_tables"
        "br_netfilter" # https://serverfault.com/a/964491
      ];
    };

  security = lib.mkIf config.virtualisation.docker.enable {
    lockKernelModules = false;
  };

  users =
    let
      inherit (config.virtualisation.docker.daemon.settings) group;
    in
    lib.mkIf (builtins.isString group) {
      users = {
        "${user}" = {
          extraGroups = [ group ];
        };
      };
    };

  virtualisation = {
    docker = {
      enable = lib.mkDefault true;
      enableOnBoot = lib.mkDefault true;
      package = pkgs.docker;

      logDriver = "journald";

      rootless = {
        enable = lib.mkDefault false;
        inherit (config.virtualisation.docker) package;
        setSocketVariable = true;
      };

      daemon = {
        settings = lib.mkMerge [
          {
            live-restore = true;

            # storage-driver = lib.mkDefault (
            #   if config.virtualisation.docker.daemon.settings.features.containerd-snapshotter then
            #     "overlayfs"
            #   else
            #     "overlay2"
            # );
            storage-driver = lib.mkDefault "overlay2";
            data-root = lib.mkDefault "/var/lib/docker";

            selinux-enabled = !config.security.apparmor.enable;

            exec-opts = [ "native.cgroupdriver=systemd" ];
            cgroup-parent = "docker.slice";
            default-cgroupns-mode = "private";

            group = "docker";
            # userns-remap = "${user}";

            experimental = true;
            features = {
              buildkit = true;
              cdi = true;
              # containerd-snapshotter = (config.virtualisation.docker.daemon.settings.containerd or null) != null;
            };

            # bridge = "docker0";

            # ip = lib.mkDefault "0.0.0.0";
            # ipv6 = config.networking.enableIPv6;
            # default-gateway = lib.mkDefault (
            # config.virtualisation.docker.daemon.settings.bip or config.networking.defaultGateway.address or null
            # );
            ip-masq = true;
            ip-forward = (builtins.toString (config.boot.kernel.sysctl."net.ipv4.ip_forward" or 0)) == "1";

            dns = lib.mkDefault [
              "1.1.1.1"
              "1.0.0.1"
              "8.8.8.8"
              "8.8.4.4"
            ];
            # dns = lib.mkDefault config.networking.nameservers;

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

              {
                base = "10.0.0.0/24";
                size = 24;
              }

              {
                base = "10.0.1.0/24";
                size = 24;
              }

              {
                base = "10.0.2.0/24";
                size = 24;
              }

              {
                base = "10.0.3.0/24";
                size = 24;
              }
            ];

            # iptables = !config.networking.nftables.enable;
            # ip6tables = !config.networking.nftables.enable;
            iptables = true;
            ip6tables = true;

            default-shm-size = "64M";
            default-ulimits = {
              nofile = {
                Hard = 64000;
                Name = "nofile";
                Soft = 64000;
              };
            };

            debug = lib.mkDefault true;
          }

          (lib.mkIf ((builtins.hasAttr "domain" config.networking) && config.networking.domain != null) {
            tls = true;
            tlscert = config.age.secrets."${config.networking.domain}.crt".path;
            tlskey = config.age.secrets."${config.networking.domain}.key".path;
            tlsverify = true;
          })

          (lib.mkIf config.virtualisation.containerd.enable {
            containerd = config.virtualisation.containerd.settings.grpc.address;
            containerd-namespace = "docker";
            containerd-plugins-namespace = "docker-plugins";
          })
        ];
      };
    };
  };

  networking =
    let
      bridge = config.virtualisation.docker.daemon.settings.bridge or "docker0";
      inherit (config.virtualisation.docker.daemon.settings) bip;
      interfaces =
        # config.networking.firewall.trustedInterfaces ++
        [
          "wifi"
          "eth"
        ];
    in
    lib.mkIf config.virtualisation.docker.enable {
      firewall = {
        trustedInterfaces = [ bridge ];
        checkReversePath = lib.mkForce false;
        filterForward = false;

        # https://unix.stackexchange.com/a/657786
        extraCommands = lib.mkIf (
          !config.networking.nftables.enable && config.virtualisation.docker.daemon.settings.iptables
        ) extraCommands;
      };

      nftables = {
        tables = {
          docker-filter = {
            enable = true;

            name = "filter";
            family = "inet";

            content = ''
              chain forward {
                  type filter hook forward priority filter + 10; policy drop;
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
                        iifname "${iface}" ip saddr != ${bip} counter drop
                      '') (builtins.filter (iface: iface != bridge) interfaces)
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
                        iifname "${iface}" icmp type echo-request accept
                        iifname "${iface}" ip saddr ${bip} tcp dport 22 accept
                        iifname "${iface}" ip saddr ${bip} tcp dport 80 accept
                        iifname "${iface}" ip saddr ${bip} tcp dport 443 accept
                      '') (builtins.filter (iface: iface != bridge) interfaces)
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
    packages = [
      (pkgs.writeTextFile {
        name = "docker-mark";
        destination = "/etc/systemd/system/docker.service.d/mark.conf";

        text =
          if config.virtualisation.docker.daemon.settings.iptables then
            ''
              [Service]
              PrivateNetwork=yes
              PrivateMounts=No

              ${lib.strings.concatLines (
                builtins.map
                  (
                    cmd:
                    "ExecStartPre=-${
                      if (builtins.match "^ip6?tables[[:blank:]].*" cmd) != null then
                        "${pkgs.iptables}/bin/${cmd}"
                      else
                        cmd
                    }"
                  )
                  (
                    builtins.filter (cmd: (builtins.match "^[[:blank:]]*#.*" cmd) == null) (
                      lib.strings.splitString "\n" extraCommands
                    )
                  )
              )}
            ''
          else
            ''
              [Service]
              PrivateNetwork=No
              PrivateMounts=No

              ExecStartPre=-${pkgs.runtimeShell} -c "true"
            '';
      })

      (pkgs.writeTextFile {
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
    systemPackages = with pkgs; [
      docker-compose
      docker
    ];
  };
}
