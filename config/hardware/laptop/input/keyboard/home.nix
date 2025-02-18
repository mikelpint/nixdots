{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = { input = { kb_layout = lib.mkForce "es, us"; }; };
      };
    };
  };
}
