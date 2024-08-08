{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        xwayland = {
          #hidpi = lib.mkDefault true;
        };
      };
    };
  };
}
