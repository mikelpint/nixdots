{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          windowrulev2 = [
            "float, class:^([Ss]team)$, title:^((?![Ss]team).*)$"
            "workspace 3 silent, class:^([Ss]team)$, title:^([Ss]team)$"
            "tile, class:^([Ss]team)$, title:^([Ss]team)$"
          ];
        };
      };
    };
  };
}
