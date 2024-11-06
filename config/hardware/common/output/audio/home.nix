{ id, ... }:
let
  device = if id == null then "@DEFAULT_AUDIO_SINK@" else (builtins.toString id);
in
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bindle = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 ${device} 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume ${device} 5%-"
          ];

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute ${device} toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"
          ];
        };
      };
    };
  };
}
