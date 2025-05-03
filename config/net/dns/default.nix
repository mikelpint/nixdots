{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./dnscrypt-proxy
    ./systemd-resolved
  ];

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"

      "127.0.0.1"
    ] ++ (if config.networking.enableIPv6 then [ "::1" ] else [ ]);

    dhcpcd = {
      extraConfig = "nohook resolv.conf";
    };

    networkmanager = {
      dns = lib.mkOverride 75 "none";

      insertNameservers = config.networking.nameservers;
    };

    resolvconf = {
      enable = !config.services.resolved.enable;
      useLocalResolver = true;
    };
  };

  system = {
    nssDatabases = {
      hosts = lib.mkMerge [
        (lib.mkBefore [ "mdns_minimal [NOTFOUND=return]" ])
        (lib.mkAfter [ "mdns" ])
      ];
    };
  };

  environment = {
    etc = {
      hosts = {
        mode = "0644";
      };
    };

    systemPackages = with pkgs; [ whois ];
  };
}
