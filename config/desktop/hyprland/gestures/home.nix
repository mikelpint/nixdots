{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          gestures = {
            workspace_swipe = lib.mkDefault false;
          };
        };
      };
    };
  };
}
