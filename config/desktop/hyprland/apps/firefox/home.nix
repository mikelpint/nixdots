{ lib, config, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          envd = [
            "MOZ_ENABLE_WAYLAND,1"
            "MOZ_GTK_TITLEBAR_DECORATION,client"
          ];
        };
      };
    };
  };

  programs = {
    firefox =
      (lib.mkIf false {
        profiles = lib.attrsets.listToAttrs (
          builtins.map (name: {
            inherit name;
            value = {
              settings = {
                browser = {
                  tabs = {
                    inTitlebar = 1;
                  };
                };
              };
            };
          }) (lib.attrsets.attrNames (config.programs.firefox.profiles or { }))
        );
      })
      // {
        profiles = {
          default = {
            settings = {
              browser = {
                cache = {
                  memory = {
                    enable = true;

                    capacity = 39628.20249; # 41297 - (41606 / (1 + ((80 / 1.16) ^ 0.75))) from https://wiki.archlinux.org/title/Firefox/Tweaks#Turn_off_the_disk_cache
                  };
                };
              };
            };
          };
        };
      };
  };
}
