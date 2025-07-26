{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = lib.mkDefault true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;

          PairableTimeout = 30;
          DiscoverableTimeout = 30;
          TemporaryTimeout = 0;
          MaxControllers = 1;
        };

        Policy = {
          AutoEnable = false;
          Privacy = "network/on";
        };
      };
    };
  };

  services = lib.mkIf (config.hardware.bluetooth.enable or false) {
    blueman = {
      enable = true;
    };
  };

  users = lib.mkIf (config.hardware.bluetooth.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [ "bluetooth" ];
      };
    };
  };
}
