{ config, lib, ... }:
with lib;
with lib.custom;
let cfg = config.presets.desktop;
in {
  options = {
    presets = {
      desktop = with types; {
        enable = mkBoolOpt false "Enable the desktop preset";
      };
    };
  };

  config = mkIf cfg.enable {
    apps = {
      firefox = enabled;
      libreoffice = enabled;
    };

    desktop = {
      hyprland = enabled;

      addons = {
        alacritty = enabled;
        bemenu = disabled;
        foot = disabled;
        kitty = disabled;
        rofi = disabled;
        st = disabled;
        swww = enabled;
        waybar = enabled;
        wezterm = disabled;
        wofi = enabled;
        xdg-portal = enabled;
      };
    };

    services = {
      xserver = {
        enable = true;
        displayManager = { gdm = enabled; };
      };
    };
  };
}
