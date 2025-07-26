{ lib, ... }:
{
  "custom/launcher" = {
    format = "󱗼";
    tooltip = false;
    on-click-release = lib.optionalString "wofi --show drun -I -s ~/.config/wofi/style.css";
  };
}
