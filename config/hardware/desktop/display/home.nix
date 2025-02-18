{ lib, osConfig, pkgs, ... }:

let
  isnvidia = builtins.elem "nvidia" osConfig.services.xserver.videoDrivers;

  monitors = if isnvidia then [
    {
      name = "DVI-D-1";
      px = [ 2560 1440 ];
      hz = 59.91;
      scale = 1.25;

      ws = 1;
    }

    {
      name = "DP-1";
      px = [ 1920 1080 ];
      hz = 59.96;
      scale = 1.25;
    }
  ] else [
    {
      px = [ 2560 1440 ];
      hz = 59.95;
      scale = 1.25;

      ws = 1;
    }

    {
      px = [ 1920 1080 ];
      hz = 165;
      scale = 1.25;
    }
  ];
in {
  imports = [
    #../../../desktop/hyprland/plugins/csgo-vulkan-fix
    #../../../desktop/hyprland/plugins/hyprtrails
  ];

  home = {
    sessionVariables = { SDL_VIDEODRIVER = "wayland,x11,windows"; };

    packages = with pkgs;
      [
        (writeShellScriptBin "set_primary_monitor" ''
          xrandr --output ${
            (builtins.elemAt monitors 0).name or "DP-1"
          } --primary
        '')
      ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = lib.mkForce [ "set_primary_monitor" ];

          monitor = lib.mkForce (lib.lists.imap0 (idx: mon:
            "${mon.name or "DP-${toString (idx + 1)}"}, ${
              toString (builtins.elemAt mon.px 0)
            }x${toString (builtins.elemAt mon.px 1)}@${
              toString (mon.hz or 60)
            }, ${
              toString (lib.lists.foldr (mon: acc:
                acc + ((builtins.elemAt mon.px 0) / (mon.scale or 1))) 0
                (lib.lists.sublist 0 idx monitors))
            }x0, ${toString (mon.scale or 1)}") monitors);

          workspace = lib.mkForce (lib.lists.imap1 (idx: mon:
            "${mon.name or "DP-${toString idx}"}, ${toString (mon.ws or 10)}")
            monitors);

          render = { direct_scanout = lib.mkForce false; };

          misc = {
            vfr = lib.mkForce false;
            vrr = lib.mkForce (if isnvidia then 0 else 1);
          };

          decoration = {
            blur = { enabled = lib.mkForce true; };

            shadow = { enabled = lib.mkForce true; };
          };
        };
      };
    };
  };
}
