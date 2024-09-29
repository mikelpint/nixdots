{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      cliphist
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "wl-paste --watch cliphist store" ];

          bind = [ "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy" ];
        };
      };
    };
  };
}
