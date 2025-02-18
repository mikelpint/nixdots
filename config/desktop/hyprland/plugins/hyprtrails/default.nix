{ inputs, pkgs, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        plugins =
          [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails ];

        settings = { plugin = { hyprtrails = { color = "rgb(f5bde6)"; }; }; };
      };
    };
  };
}
