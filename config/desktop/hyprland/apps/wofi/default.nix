{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bind = [
            "$mainMod, r, exec, pkill wofi; wofi --show drun -I -s ~/.config/wofi/style.css DP-3"
          ];

          windowrulev2 = [ "opacity 1.0 1.0,class:^(wofi)$" ];
        };
      };
    };
  };
}
