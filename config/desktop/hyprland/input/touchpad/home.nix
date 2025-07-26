{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            touchpad = {
              natural_scroll = lib.mkDefault 1;
            };
          };
        };
      };
    };
  };
}
