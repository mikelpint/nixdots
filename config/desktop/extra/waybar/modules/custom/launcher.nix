{ config, lib, ... }:
{
  "custom/launcher" = {
    format = "󱗼";
    tooltip = false;
  }
  // (lib.optionalAttrs (config.programs.wofi.enable or false) {
    on-click-release = "wofi --show drun -I -s ~/.config/wofi/style.css";
  });
}
