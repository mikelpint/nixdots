{ pkgs, inputs, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        systemd = {
          enable = true;
          variables = [ "--all" ];
        };
      };
    };
  };
}
