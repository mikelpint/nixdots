{ config, pkgs, ... }:
{
  hardware = {
    openrazer = {
      enable = true;

      verboseLogging = false;
      syncEffectsEnabled = true;

      devicesOffOnScreensaver = true;
      batteryNotifier = {
        enable = false;
        frequency = 600;
        percentage = 33;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      config.boot.kernelPackages.openrazer
      openrazer-daemon
      polychromatic
    ];
  };
}
