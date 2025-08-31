{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = lib.mkIf false {
          gestures = {
            workspace_swipe = lib.mkDefault false;
          };
        };
      };
    };
  };
}
