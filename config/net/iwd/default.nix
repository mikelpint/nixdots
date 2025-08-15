{
  pkgs,
  lib,
  config,
  ...
}:
{
  networking = {
    wireless = {
      iwd = {
        enable = true;
        package = pkgs.iwd;

        settings = {
          General = {
            ControlPortOverNL80211 = lib.mkDefault true;
            EnableNetworkConfiguration = lib.mkDefault true;
          };

          Ipv4 = {
            SendHostname = lib.mkDefault true;
          };

          IPv6 = {
            Enabled = config.networking.enableIPv6 or false;
          };

          Settings = {
            Autoconnect = lib.mkDefault true;
          };

          Scan = {
            DisablePeriodicScan = lib.mkDefault true;
          };

          Network = {
            NameResolvingService = lib.mkDefault (
              if config.services.resolved.enable or false then "systemd" else "none"
            );
            RoutePriorityOffset = lib.mkDefault 300;
          };

          Rank = {
            BandModifier2_4GHz = lib.mkDefault 0.5;
            BandModifier5GHz = lib.mkDefault 1.0;
            BandModifier6GHz = lib.mkDefault 1.5;
          };
        };
      };
    };

    networkmanager = {
      wifi = {
        backend = "iwd";
      };
    };
  };

  environment = lib.mkIf (config.networking.wireless.iwd.enable or false) {
    systemPackages = [ config.networking.wireless.iwd.package or pkgs.iwd ];
  };

  systemd = lib.mkIf (config.networking.wireless.iwd.enable or false) {
    services = {
      iwd = {
        after = [
          "network-pre.target"
          "sys-subsystem-net-devices-wifi.device"
        ];
        wants = [
          "network.target"
          "sys-subsystem-net-devices-wifi.device"
        ];
      };
    };
  };
}
