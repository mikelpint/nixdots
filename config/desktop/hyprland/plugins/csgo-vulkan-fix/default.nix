{ inputs, pkgs, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix ];

        settings = {
          plugin = {
            csgo-vulkan-fix = {
              class = "cs2";

              fix_mouse = true;
            };
          };
        };
      };
    };
  };
}
