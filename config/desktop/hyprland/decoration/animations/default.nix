{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          animations = {
            enabled = true;

            bezier = [
              "linear, 0.0, 0.0, 1.0, 1.0"
              "pace, 0.46, 1, 0.29, 0.99"
              "overshot, 0.13, 0.99, 0.29, 1.1"
              "md3_decel, 0.05, 0.7, 0.1, 1"
            ];

            animation = [
              "windowsIn, 1, 6, md3_decel, slide"
              "windowsOut, 1, 6, md3_decel, slide"
              "windowsMove, 1, 6, md3_decel, slide"

              "fade, 1, 10, md3_decel"

              "workspaces, 1, 9, md3_decel, slide"
              "workspaces, 1, 6, default"
              "specialWorkspace, 1, 8, md3_decel, slide"

              "border, 1, 10, md3_decel"
              "borderangle, 1, 100, linear, loop"
            ];
          };
        };
      };
    };
  };
}
