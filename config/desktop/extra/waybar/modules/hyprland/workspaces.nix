{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  "hyprland/workspaces" = {
    active-only = false;
    on-click = "activate";

    disable-scroll = false;

    format = "{icon}";
    format-icons = {
      "1" = "1";
      "2" = "2";
      "3" = "3";
      "4" = "4";
      "5" = "5";
      "6" = "6";
      "7" = "7";
      "8" = "8";
      "9" = "9";
      "10" = "10";

      sort-by-number = true;
    };
  }
  // (lib.optionalAttrs
    (
      (config.wayland.windowManager.hyprland.enable or false)
      || (osConfig.programs.hyprland.enable or false)
    )
    (
      let
        hyprland =
          config.wayland.windowManager.hyprland.package or osConfig.programs.hyprland.package
            or pkgs.hyprland;
      in
      {
        on-scroll-up = "${hyprland}/bin/hyprctl dispatch workspace e+1";
        on-scroll-down = "${hyprland}/bin/hyprctl dispatch workspace e-1";
      }
    )
  );
}
