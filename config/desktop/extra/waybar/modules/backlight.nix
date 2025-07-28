{
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  "backlight" = {
    format = "{icon} {percent}%";
    format-icons = [
      "󰃞"
      "󰃟"
      "󰃠"
    ];
  }
  // (lib.optionalAttrs (osConfig.programs.light.enable or false) (
    let
      light = osConfig.programs.light.package or pkgs.light;
    in
    {
      on-scroll-up = "${light}/bin/light -A 1";
      on-scroll-down = "${light}/bin/light -U 1";
    }
  ));
}
