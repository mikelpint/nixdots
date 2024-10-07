{ inputs, pkgs, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        plugins = [ inputs.hyprgrass.packages.${pkgs.system}.default ];

        settings = {
          plugin = {
            touch_gestures = {
              sensitivity = 1.0;

              workspace_swipe_fingers = 3;

              long_press_delay = 400;

              worskpace_swipe_edge = "d";
              edge_margin = 10;

              experimental = {
                send_cancel = 0;
              };
            };
          };

          gestures = {
            workspace_swipe = true;
            workspace_swip_cancel_ratio = 0.15;
          };
        };
      };
    };
  };
}
