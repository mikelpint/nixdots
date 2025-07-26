{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          debug = {
            disable_logs = lib.mkDefault true;
            damage_tracking = 2;
          };
        };
      };
    };
  };
}
