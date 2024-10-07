{ pkgs, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_wallpaper" ];
        };
      };
    };
  };
}
