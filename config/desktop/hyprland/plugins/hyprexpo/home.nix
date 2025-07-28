{ inputs, pkgs, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo ];

        settings = {
          plugin = {
            hyprexpo = {
              rows = 3;
              columns = 3;

              gap_size = 240;
              bg_col = "rgb(f5bde6)";
              workspace_method = "center current";

              enable_gesture = true;
              gesture_fingers = 3;
              gesture_distance = 300;
              gesture_positive = true;
            };
          };

          bind = [ "$altMod, tab, hyprexpo:expo, toggle" ];
        };
      };
    };
  };
}
