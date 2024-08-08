{ pkgs, ... }: {
  home = { packages = with pkgs; [ easyeffects ]; };

  wayland = {
    windowManager = {
      hyprland = {
        settings = { exec-once = [ "easyeffects --gapplication-service" ]; };
      };
    };
  };
}
