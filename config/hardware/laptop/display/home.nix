{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkForce [ "eDP-1,1920x1080@60,0x0,1.5" ];

          misc = {
            vfr = lib.mkForce true;
          };

          decoration = {
            blur = {
              enabled = lib.mkForce false;
            };

            drop_shadow = lib.mkForce false;
          };
        };
      };
    };
  };
}
