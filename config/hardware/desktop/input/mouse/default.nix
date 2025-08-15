{
  config,
  pkgs,
  lib,
  user,
  ...
}:
{
  hardware = {
    openrazer = {
      enable = true;
      syncEffectsEnabled = true;

      verboseLogging = false;
      keyStatistics = false;

      devicesOffOnScreensaver = true;
      batteryNotifier = {
        enable = false;
        frequency = 600;
        percentage = 33;
      };
    };
  };

  users = lib.mkIf (config.hardware.openrazer.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [ "openrazer" ];
      };
    };
  };

  boot = lib.mkIf (config.hardware.openrazer.enable or false) {
    kernelModules = [ "openrazer" ];
    extraModulePackages = with config.boot.kernelPackages; [ openrazer ];
  };

  environment = {
    systemPackages = with pkgs; [
      config.boot.kernelPackages.openrazer
      openrazer-daemon
      polychromatic
    ];
  };

  services = lib.mkIf (config.hardware.openrazer.enable or false) {
    udev = {
      packages = with pkgs; [ openrazer-daemon ];
    };
  };
}
