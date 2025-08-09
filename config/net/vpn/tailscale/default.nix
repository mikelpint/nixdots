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
        package = config.services.tailscale.package.derper or pkgs.tailscale.derper;

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

  environment = lib.mkIf (config.services.tailscale.enable or false) {
    systemPackages = [
      (config.services.tailscale.package or pkgs.tailscale)
      pkgs.tailscale-systray
    ];
  };

  systemd = lib.mkIf (config.services.tailscale.enable or false) {
    services = {
      tailscaled = {
        after = [
          "network-pre.target"
          "network-online.target"
          "sys-subsystem-net-devices-${config.services.tailscale.interfaceName or "tailscale0"}.device"
        ]
        ++ (lib.optionals (config.networking.networkmanager.enable or false) [
          "NetworkManager-wait-online.service"
        ])
        ++ (lib.optionals (config.services.dnscrypt-proxy2.enable or false) [ "dnscrypt-proxy2.service" ])
        ++ (lib.optionals (config.services.resolved.enable or false) [ "systemd-resolved.service" ])
        ++ (lib.optionals (config.networking.resolvconf.enable or false) [ "resolvconf.service" ])
        ++ (lib.optionals (config.networking.wireless.iwd.enable or false) [ "iwd.service" ]);

        wants = config.systemd.services.tailscaled.after or [ ];

        # https://tailscale.com/kb/1279/security-node-hardening#alternative-use-userspace-networking

        serviceConfig = {
          ExecStartPre = "${config.services.tailscale.package or pkgs.tailscale}/bin/tailscaled --cleanup";
          ExecStopPre = "${config.services.tailscale.package or pkgs.tailscale}/bin/tailscaled --cleanup";

          User = config.services.tailscale.permitCertUid or "tailscale";
          Group = config.services.tailscale.permitCertUid or "tailscale";

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
        // (lib.mkIf (builtins.elem "tun" (config.boot.kernelModules or [ ])) {
          AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN";
          ProtectKernelModules = "yes";
        });
      };
    };
  };

  networking = lib.mkIf (config.services.tailscale.enable or false) {
    firewall = {
      checkReversePath = lib.mkDefault "loose";
      trustedInterfaces = [ (config.services.tailscale.interfaceName or "tailscale0") ];

      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        (config.services.tailscale.derper.stunPort or 3478)
      ]
      ++ (
        let
          port = config.services.tailscale.port or 8010;
        in
        lib.optionals (port != 0) [
          port
        ]
      );
    };

    interfaces = {
      "${config.services.tailscale.interfaceName or "tailscale0"}" = {
        useDHCP = false;
      };
    };
  };
}
