{
  lib,
  config,
  osConfig,
  ...
}:
{
  imports = [ ../../../extra/wezterm/home.nix ];

  home = lib.mkIf (config.programs.wezterm.enable or false) {
    shellAliases = {
      wezterm = "WAYLAND_DISPLAY=1 wezterm";
    };
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = lib.mkIf (config.programs.wezterm.enable or false) {
          bind = [
            "$mainMod, RETURN, exec, ${
              lib.optionalString (osConfig.programs.hyprland.withUWSM or false) "uwsm app -- "
            }wezterm start --always-new-process"
          ];

          windowrule = [ "tile, title:^(wezterm)$" ];

          windowrulev2 = [
            "float, class:^(org.wezfurlong.wezterm)$"
            "tile, class:^(org.wezfurlong.wezterm)$"
          ];
        };
      };
    };
  };
}
