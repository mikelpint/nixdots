let
  id = 61;
in
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bindle = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 ${builtins.toString id} 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume ${builtins.toString id} 5%-"
          ];

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute ${builtins.toString id} toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };
    };
  };
}
