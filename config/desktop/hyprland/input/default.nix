{ lib, ... }: {
  imports = [ ./keyboard ./mouse ./touchpad ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            repeat_delay = lib.mkDefault 140;
            repeat_rate = lib.mkDefault 30;
          };
        };
      };
    };
  };
}
