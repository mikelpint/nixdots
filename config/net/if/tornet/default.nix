# https://www.void.gr/kargig/blog/2016/12/12/firejail-with-tor-howto/

{ lib, pkgs, ... }:

let
  address = "10.100.100.1";
  prefixLength = 24;

  enable = false;
in
{
  systemd = lib.mkIf enable {
    network = {
      enable = true;

      netdevs = {
        tornet = {
          enable = true;

          netdevConfig = {
            Kind = "bridge";
            Name = "tornet";
          };
        };
      };

      networks = lib.mkIf enable {
        tornet = {
          matchConfig = {
            Name = "tornet";
          };

          DHCP = "no";

          networkConfig = {
            ConfigureWithoutCarrier = true;
            Address = "${address}/${builtins.toString prefixLength}";
          };

          linkConfig = {
            ActivationPolicy = "always-up";
          };
        };
      };
    };
  };

  boot = lib.mkIf enable {
    kernel = {
      sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv4.conf.tornet.route_localnet" = 1;
      };
    };
  };

  networking = lib.mkIf enable {
    nat = {
      internalInterfaces = [ "tornet" ];
      forwardPorts = [
        {
          destination = "127.0.0.1:5353";
          proto = "udp";
          sourcePort = 53;
        }
      ];
    };

    firewall = {
      interfaces = {
        tornet = {
          allowedTCPPorts = [ 9040 ];
          allowedUDPPorts = [ 5353 ];
        };
      };
    };

    nftables = {
      tables = {
        tornet-filter = {
          enable = true;

          name = "filter";
          family = "inet";

          content = ''
            chain input {
                ct state invalid drop

                ct state related,established accept
            }

            chain forward {
                iifname "tornet" oifname "eth" ip protocol tcp accept
                iifname "tornet" oifname "eth" ip protocol udp udp dport 53 accept

                iifname "tornet" oifname "wifi" ip protocol tcp accept
                iifname "tornet" oifname "wifi" ip protocol udp udp dport 53 accept
            }
          '';
        };

        tornet-nat = {
          enable = true;

          name = "nat";
          family = "inet";

          content = ''
            chain prerouting {
                type nat hook prerouting priority 0; policy drop;

                iifname "tornet" ip protocol udp udp dport 32 dnat to 127.0.0.1:5353
                iifname "tornet" ip protocol tcp dnat to 127.0.0.1:9040
            }

            chain postrouting {
                type nat hook postrouting priority 100; policy accept;

                ip saddr ${address}/${builtins.toString prefixLength} oifname "eth" masquerade
                ip saddr ${address}/${builtins.toString prefixLength} oifname "wifi" masquerade
            }
          '';
        };
      };
    };
  };

  services = lib.mkIf enable {
    tor = {
      enable = true;

      settings = {
        TransPort = [ 9040 ];
        VirtualAddrNetwork = "172.30.0.0/16";
        DNSPort = 5353;
        IsolateDestAddr = true;
        AutomapHostsOnResolve = true;
      };
    };

    networkd-dispatcher = {
      enable = true;

      rules = {
        "restart-tor" = {
          onState = [
            "routable"
            "off"
          ];
          script = ''
            #!${pkgs.runtimeShell}
            if [[ $IFACE == "eth" && $AdministrativeState == "configured" ]] || [[ $IFACE == "wifi" && $AdministrativeState == "configured" ]]; then
              echo "Restarting Tor ..."
              systemctl restart tor
            fi
            exit 0
          '';
        };
      };
    };
  };
}
