{ config, pkgs, ... }:
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

  boot = {
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

  services = {
    udev = {
      packages = with pkgs; [ openrazer-daemon ];
    };
  };
}
