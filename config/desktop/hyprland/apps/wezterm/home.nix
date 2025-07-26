{
  home = {
    shellAliases = {
      wezterm = "WAYLAND_DISPLAY=1 wezterm";
    };
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bind = [ "$mainMod, RETURN, exec, wezterm start --always-new-process" ];

          windowrule = [ "tile,title:^(wezterm)$" ];

          windowrulev2 = [
            "float,class:^(org.wezfurlong.wezterm)$"
            "tile,class:^(org.wezfurlong.wezterm)$"
          ];
        };
      };
    };
  };
}
