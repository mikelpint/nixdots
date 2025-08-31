{
  inputs,
  pkgs,
  lib,
  osConfig,
  config,
  ...
}:
{
  wayland = {
    windowManager = {
      hyprland = {
        plugins = lib.optionals false (
          [
            inputs.hyprgrass.packages.${pkgs.system}.default
          ]
          ++ (lib.optionals (osConfig.services.pulseaudio.enable or false) [
            inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
          ])
        );

        settings =
          lib.mkIf
            (builtins.any (
              let
                hyprgrass = lib.getName inputs.hyprgrass.packages.${pkgs.system}.default;
                hyprgrass-pulse = lib.getName inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse;
              in
              x:
              let
                name = if lib.attrsets.isDerivation x then lib.getName x else null;
              in
              name == hyprgrass || name == hyprgrass-pulse
            ) (config.wayland.windowManager.hyprland.plugins or [ ]))
            {
              plugin = {
                touch_gestures = {
                  sensitivity = 1.0;

                  workspace_swipe_fingers = 3;

                  long_press_delay = 400;

                  worskpace_swipe_edge = "d";
                  edge_margin = 10;

                  experimental = {
                    send_cancel = 0;
                  };
                };
              };

              gestures = lib.mkIf false {
                workspace_swipe = true;
                workspace_swipe_cancel_ratio = 0.15;
              };
            };
      };
    };
  };
}
