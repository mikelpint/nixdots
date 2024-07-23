{ lib, ... }:
{
  programs = {
    waybar = {
      settings = {
        mainBar = {
          modules-right = lib.mkForce [
            "tray"
            "pulseaudio"
            "battery"
            "backlight"
            "network"
            "clock"
          ];
        };
      };
    };
  };
}
