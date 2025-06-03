{
  lib,
  config,
  pkgs,
  self,
  user,
  ...
}:
{
  imports = [ ../../tun ];

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
      permitCertUid = "tailscale";

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

        # https://tailscale.com/kb/1279/security-node-hardening#alternative-use-userspace-networking

        serviceConfig =
          {
            ExecStartPre = "${config.services.tailscale.package}/bin/tailscaled --cleanup";
            ExecStopPre = "${config.services.tailscale.package}/bin/tailscaled --cleanup";

            User = config.services.tailscale.permitCertUid;
            Group = config.services.tailscale.permitCertUid;

            DeviceAllow = [
              "/dev/tun"
              "/dev/net/tun"
            ];
            AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN CAP_SYS_MODULE";
            ProtectKernelModules = "no";
            RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
            NoNewPrivileges = "yes";
            PrivateTmp = "yes";
            PrivateMounts = "yes";
            RestrictNamespaces = "yes";
            RestrictRealtime = "yes";
            RestrictSUIDSGID = "yes";
            MemoryDenyWriteExecute = "yes";
            LockPersonality = "yes";
            ProtectHome = "yes";
            ProtectControlGroups = "yes";
            ProtectKernelLogs = "yes";
            ProtectSystem = "full";
            ProtectProc = "noaccess";
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@known"
              "~@clock @cpu-emulation @raw-io @reboot @mount @obsolete @swap @debug @keyring @mount @pkey"
            ];
          }
          // (lib.mkIf (builtins.elem "tun" config.boot.kernelModules) {
            AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN";
            ProtectKernelModules = "yes";
          });
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
