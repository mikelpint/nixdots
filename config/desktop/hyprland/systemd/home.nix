{ osConfig, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        systemd = {
          enable = !(osConfig.programs.hyprland.withUWSM or false);
          variables = [ "--all" ];
        };
      };
    };
  };
}
