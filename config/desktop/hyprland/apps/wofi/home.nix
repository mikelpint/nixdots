{
  config,
  lib,
  osConfig,
  ...
}:
{
  imports = [ ../../../extra/wofi/home.nix ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = lib.mkIf (config.programs.wofi.enable or false) {
          bind = [
            "$mainMod, r, exec, ${
              lib.optionalString (osConfig.programs.hyprland.withUWSM or false) "uwsm app -- "
            }pkill wofi; wofi --show drun -I -s ~/.config/wofi/style.css DP-3"
          ];

          windowrulev2 = [ "opacity 1.0 1.0, class:^(wofi)$" ];
        };
      };
    };
  };
}
