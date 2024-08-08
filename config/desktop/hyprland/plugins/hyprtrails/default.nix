{ inputs, pkgs, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        plugins = [ inputs.hycov.packages.${pkgs.system}.hycov ];

        settings = {
          plugin = {
            hycov = {
              overview_gappo = 60;
              overview_gappii = 24;

              hotarea_size = 10;
              enable_hotarea = 0;
            };
          };
        };
      };
    };
  };
}
