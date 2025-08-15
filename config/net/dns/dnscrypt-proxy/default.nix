# https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/dns.nix

{
  lib,
  config,
  pkgs,
  ...
}:
let
  port = 51;
in
{
  services = {
    dnscrypt-proxy2 = {
      enable = true;

      settings = {
        listen_addresses = [
          "127.0.0.1:${toString port}"
        ]
        ++ (lib.optional (false || (config.networking.enableIPv6 or false)) "::1:${toString port}");

        ipv6_servers = config.networking.enableIPv6 or false;
        require_dnssec = true;

        server_names = [
          "cloudflare"
          "cloudflare-ipv6"
          "cloudflare-security"
          "cloudflare-security-ipv6"
          "adguard-dns-doh"
          "mullvad-adblock-doh"
          "mullvad-doh"
          "nextdns"
          "nextdns-ipv6"
          "quad9-dnscrypt-ipv4-filter-pri"
          "google"
          "google-ipv6"
          "ibksturm"
        ];

        sources = {
          public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];

            cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
        };
      };
    };

    resolved = {
      enable = !((config.services.dnscrypt-proxy2.enable or false) && port == 53);
    };
  };

  systemd = {
    services = {
      dnscrypt-proxy2 = {
        serviceConfig = {
          StateDirectory = "dnscrypt-proxy";
          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        };
      };
    };
  };

  networking = lib.mkIf (config.services.dnscrypt-proxy2.enable or false) {
    nameservers = lib.mkMerge [
      (lib.mkAfter ([ "127.0.0.1" ] ++ (lib.optional (config.networking.enableIPv6 or false) "::1")))
    ];

    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];

      extraCommands = lib.mkIf (!config.networking.nftables.enable && port != 53) ''
        ip6tables --table nat --flush OUTPUT
        ${lib.flip (lib.concatMapStringsSep "\n") [ "udp" "tcp" ] (proto: ''
          ip6tables --table nat --append OUTPUT \
            --protocol ${proto} --destination ::1 --destination-port 53 \
            --jump REDIRECT --to-ports ${toString port}
        '')}
      '';
    };

    nftables = {
      tables = {
        nat = {
          enable = (config.networking.nftables.enable or false) && port != 53;
          name = "nat";
          family = "ip6";
          content = ''
            chain output {
              type nat hook prerouting priority -100; policy accept;
              tcp dport 53 redirect to :${toString port}
            }
          '';
        };
      };
    };
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        dnscrypt-proxy = lib.mkIf (config.services.dnscrypt-proxy2.enable or false) {
          executable = "${
            lib.getBin (config.services.dnscrypt-proxy.package or pkgs.dnscrypt-proxy)
          }/bin/dnscrypt-proxy";
          profile = "${pkgs.firejail}/etc/firejail/dnscrypt-proxy.profile";
        };

        dnscrypt-proxy2 = lib.mkIf (config.services.dnscrypt-proxy2.enable or false) {
          executable = "${lib.getBin pkgs.dnscrypt-proxy2}/bin/dnscrypt-proxy2";
          profile = "${pkgs.firejail}/etc/firejail/dnscrypt-proxy.profile";
        };
      };
    };
  };
}
