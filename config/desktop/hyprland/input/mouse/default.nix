{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            follow_mouse = lib.mkDefault 2;

            sensitivity = lib.mkDefault 0.0;

            accel_profile = lib.mkDefault "";
            force_no_accel = lib.mkDefault 0;
          };
        };
      };
    };
  };
}
