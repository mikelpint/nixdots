{ osConfig, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        systemd = {
          enable = !osConfig.programs.hyprland.withUWSM;
          variables = [ "--all" ];
        };
      };
    };
  };
}
