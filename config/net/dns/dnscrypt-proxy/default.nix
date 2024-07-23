# https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/nixos/dns.nix

{
  services = {
    dnscrypt-proxy2 = {
      enable = true;

      settings = {
        ipv6_servers = true;
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
  };

  systemd = {
    services = {
      dnscrypt-proxy2 = {
        serviceConfig = {
          StateDirectory = "dnscrypt-proxy";
        };
      };
    };
  };
}
