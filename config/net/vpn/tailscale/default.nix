{
  lib,
  config,
  pkgs,
  self,
  user,
  ...
}:
let
  isExitNode =
    let
      tailscale = config.services.tailscale or { };
    in
    builtins.any (x: builtins.isString x && x == "--advertise-exit-node") (
      (tailscale.extraSetFlags or [ ]) ++ (tailscale.extraUpFlags or [ ])
    );

  isSubnetRouter =
    let
      tailscale = config.services.tailscale or { };
    in
    builtins.any (
      x:
      builtins.isString x
      &&
        (builtins.match "^--advertise-routes=(((25[0-5]|(2[0-4]|1[0-9]|[1-9]|)[0-9])\\.?){4}/([0-2][0-9]|3[0-2]),?)+$" x)
        != null
    ) ((tailscale.extraSetFlags or [ ]) ++ (tailscale.extraUpFlags or [ ]));
in
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

      disableTaildrop = false;

      port = 41641;
      interfaceName = if (config.boot.isContainer or false) then "userspace-networking" else "tailscale0";

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

      authKeyFile = config.age.secrets.tailscale-authkey.path or null;
      permitCertUid = "tailscale";

      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    # https://wiki.nixos.org/wiki/Tailscale#Optimize_the_performance_of_subnet_routers_and_exit_nodes
    networkd-dispatcher =
      lib.mkIf
        (
          (config.services.tailscale.enable or false)
          && (isExitNode || isSubnetRouter)
          && (config.networking.useNetworkd.enable or false)
        )
        {
          enable = lib.mkDefault true;
          rules = {
            "50-tailscale" = {
              onState = [ "routable" ];
              script = ''
                ${lib.getExe pkgs.ethtool} -K eth rx-udp-gro-forwarding on rx-gro-list off
                ${lib.getExe pkgs.ethtool} -K wifi rx-udp-gro-forwarding on rx-gro-list off
              '';
            };
          };
        };
  };

  environment = lib.mkIf (config.services.tailscale.enable or false) {
    systemPackages = [
      (config.services.tailscale.package or pkgs.tailscale)
      pkgs.tailscale-systray
    ];

    etc = {
      "polkit-1/localauthority/10-vendor.d/tailscaled.pkla" = {
        text = ''
          [Allow tailscaled to manipulate DNS settings]
          Identity=unix-user:tailscaled
          Action=org.freedesktop.resolve1.*
          ResultAny=yes
        '';
      };
    };
  };

  systemd = lib.mkIf (config.services.tailscale.enable or false) {
    services = {
      tailscaled =
        let
          hasTun =
            (config.boot.isContainer or false)
            || !(
              (
                with lib.kernel;
                let
                  CONFIG_TUN = config.boot.kernelPackages.kernel.structuredExtraConfig.CONFIG_TUN or module;
                in
                CONFIG_TUN == yes || CONFIG_TUN == module
              )
              || (builtins.elem "tun" (config.boot.kernelModules or [ ]))
            );
        in
        {
          after = [
            "network-pre.target"
            "network-online.target"
            # "sys-subsystem-net-devices-${config.services.tailscale.interfaceName or "tailscale0"}.device"
          ]
          ++ (lib.optional (config.networking.networkmanager.enable or false) "NetworkManager.service")
          ++ (lib.optional (
            (config.networking.networkmanager.enable or false)
            && (config.systemd.services.NetworkManager-wait-online.enable or true)
          ) "NetworkManager-wait-online.service")
          ++ (lib.optional (config.services.dnscrypt-proxy2.enable or false) "dnscrypt-proxy2.service")
          ++ (lib.optional (config.services.resolved.enable or false) "systemd-resolved.service")
          ++ (lib.optional (config.networking.resolvconf.enable or false) "resolvconf.service")
          ++ (lib.optional (config.networking.wireless.iwd.enable or false) "iwd.service");

          wants = [
            "network-pre.target"
            "network-online.target"
          ];

          # bindsTo = [
          #   "sys-subsystem-net-devices-${config.services.tailscale.interfaceName or "tailscale0"}.device"
          # ];

          # https://tailscale.com/kb/1279/security-node-hardening

          serviceConfig = {
            ExecStartPre = "${config.services.tailscale.package or pkgs.tailscale}/bin/tailscaled --cleanup";
            ExecStopPost = "${config.services.tailscale.package or pkgs.tailscale}/bin/tailscaled --cleanup";
            Restart = "on-failure";

            RuntimeDirectory = "tailscale";
            RuntimeDirectoryMode = 0755;
            StateDirectory = "tailscale";
            StateDirectoryMode = 0700;
            CacheDirectory = "tailscale";
            CacheDirectoryMode = 0750;
            Type = "notify";

            User = config.services.tailscale.permitCertUid or "tailscale";
            Group = config.services.tailscale.permitCertUid or "tailscale";

            DeviceAllow = [
              "/dev/tun"
              "/dev/net/tun"
            ];

            AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN${lib.optionalString (!hasTun) " CAP_SYS_MODULE"}";
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
            ProtectKernelModules = if hasTun then "yes" else "no";
            ProtectSystem = "full";
            ProtectProc = "noaccess";
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "@known"
              "~@clock @cpu-emulation @raw-io @reboot @mount @obsolete @swap @debug @keyring @mount @pkey"
            ];
          };
        };
    };

    network = lib.mkIf (config.systemd.network.enable or false) {
      networks = {
        "50-tailscale" = {
          matchConfig = {
            Name = config.services.tailscale.interfaceName or "tailscale0";
          };

          linkConfig = {
            Unmanaged = true;
            ActivationPolicy = "manual";
          };
        };
      };
    };
  };

  users = lib.mkIf (config.services.tailscale.enable or false) {
    users = {
      "${config.services.tailscale.permitCertUid or "tailscale"}" = {
        isSystemUser = true;
        group = "${config.services.tailscale.permitCertUid or "tailscale"}";
        hashedPassword = "!";
      };
    };

    groups = {
      "${config.services.tailscale.permitCertUid or "tailscale"}" = { };
    };
  };

  networking = lib.mkIf (config.services.tailscale.enable or false) {
    firewall = {
      checkReversePath = lib.mkIf (
        let
          useRoutingFeatures = config.services.tailscale.useRoutingFeatures or "none";
        in
        useRoutingFeatures == "server" || useRoutingFeatures == "both"
      ) (lib.mkDefault "loose");
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

    dhcpcd = {
      denyInterfaces = [ "${config.services.tailscale.interfaceName or "tailscale0"}" ];
    };

    interfaces = {
      "${config.services.tailscale.interfaceName or "tailscale0"}" = {
        useDHCP = false;
      };
    };
  };

  boot = lib.mkIf (config.services.tailscale.enable or false) {
    kernel = {
      sysctl =
        lib.mkIf
          (
            let
              useRoutingFeatures = config.services.tailscale.useRoutingFeatures or "none";
            in
            useRoutingFeatures == "server" || useRoutingFeatures == "both"
          )
          {
            "net.ipv4.conf.all.forwarding" = lib.mkDefault true;
            "net.ipv6.conf.all.forwarding" = lib.mkDefault true;
          };
    };
  };
}
