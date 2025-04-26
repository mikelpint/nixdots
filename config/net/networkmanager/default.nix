{ lib, config, ... }:

let
  ifmacchanger = lib.mkIf (!config.systemd.services.macchanger.enable);
in
{
  networking = {
    networkmanager = {
      enable = true;

      ethernet = {
        macAddress = ifmacchanger "random";
      };

      wifi = {
        macAddress = ifmacchanger "random";
        scanRandMacAddress = true;
      };

      connectionConfig = {
        "ipv6-ip6-privacy" = 2;
      };
    };
  };

  systemd = {
    services = {
      NetworkManager-wait-online = {
        enable = false;
      };
    };
  };
}
