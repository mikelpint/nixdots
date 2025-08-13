{
  lib,
  config,
  user,
  ...
}:

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
        "ipv6.ip6-privacy" = 2;
      };
    };
  };

  systemd = lib.mkIf (config.networking.networkmanager.enable or false) {
    services = {
      NetworkManager-wait-online = {
        enable = false;
      };
    };
  };

  environment = lib.mkIf (config.networking.networkmanager.enable or false) {
    etc = {
      "NetworkManager/NetworkManager.conf" = {
        mode = "0644";
      };
    };
  };

  users = lib.mkIf (config.networking.networkmanager.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [ "networkmanager" ];
      };
    };
  };
}
