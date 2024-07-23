{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          envd = [
            "LIBVA_DRIVER_NAME,nvidia"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
          ];

          cursor = {
            no_hardware_cursors = true;
            allow_dumb_copy = true;
          };
        };
      };
    };
  };
}
