{
  lib,
  config,
  pkgs,
  self,
  user,
  ...
}:
{
  age = {
    secrets = {
      tailscale-authkey = {
        owner = user;
        rekeyFile = "${self}/secrets/tailscale-authkey.age";
      };
    };
  };

  services = {
    tailscale = lib.mkDefault {
      enable = true;
      package = pkgs.tailscale;

      port = 41641;
      interfaceName = if config.boot.isContainer then "userspace-networking" else "tailscale0";

      openFirewall = false;
      useRoutingFeatures = "client";

      derper = {
        enable = false;
        package = config.services.tailscale.package.derper;

        inherit (config.networking) domain;

        port = 8010;
        stunPort = 3478;
        openFirewall = false;
      };

      authKeyFile = config.age.secrets.tailscale-authkey.path;
      permitCertUid = user;

      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };

  environment = lib.mkIf config.services.tailscale.enable {
    systemPackages = [ config.services.tailscale.package ];
  };

  systemd = lib.mkIf config.services.tailscale.enable {
    services = {
      tailscaled = {
        after =
          [
            "network-online.target"
          ]
          ++ (lib.optionals config.networking.networkmanager.enable [ "NetworkManager-wait-online.service" ])
          ++ (lib.optionals config.services.dnscrypt-proxy2.enable [ "dnscrypt-proxy2.service" ])
          ++ (lib.optionals config.services.resolved.enable [ "systemd-resolved.service" ])
          ++ (lib.optionals config.networking.resolvconf.enable [ "resolvconf.service" ]);

        wants = config.systemd.services.tailscaled.after;
      };
    };
  };

  networking = lib.mkIf config.services.tailscale.enable {
    firewall = {
      checkReversePath = "loose";
      trustedInterfaces = [ config.services.tailscale.interfaceName ];

      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts =
        [
          config.services.tailscale.derper.stunPort
        ]
        ++ (lib.optionals (config.services.tailscale.port != 0) [
          config.services.tailscale.port
        ]);
    };

    interfaces = {
      "${config.services.tailscale.interfaceName}" = {
        useDHCP = false;
      };
    };
  };
}
