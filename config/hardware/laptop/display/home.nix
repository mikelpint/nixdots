{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkForce [
            "eDP-1, 1920x1080@60, 0x0, 1.25"
            ", preferred, auto, 1, mirror, DP-1"
          ];

          misc = {
            vfr = lib.mkForce true;
          };

          decoration = {
            blur = {
              enabled = lib.mkForce false;
            };

            shadow = {
              enabled = lib.mkForce false;
            };
          };

          bindle = [
            ", XF86MonBrightnessUp, exec, light -A 5"
            ", XF86MonBrightnessDown, exec, light -U 5"
          ];
        };
      };
    };
  };
}
