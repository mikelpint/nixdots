{ lib, user, ... }:
let
  # AQ_DRM_DEVICES = "/home/${user}/.config/hypr/card:/home/${user}/.config/hypr/otherCard";
  AQ_DRM_DEVICES = "/home/${user}/.config/hypr/card";
  WLR_DRM_DEVICES = AQ_DRM_DEVICES;
in
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkDefault [ ",highrr,auto,auto" ];

          envd = [
            "AQ_DRM_DEVICES,${AQ_DRM_DEVICES}"
            "WLR_DRM_DEVICES,${WLR_DRM_DEVICES}"

            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            "GDK_BACKEND,wayland,x11"
            "QT_QPA_PLATFORM,wayland;xcb"
            "CLUTTER_BACKEND,wayland"
            "SDL_VIDEODRIVER,wayland,x11,windows"

            "_JAVA_AWT_WM_NONREPARENTING,1"

            "GTK_USE_PORTAL,1"
            "NIXOS_XDG_OPEN_USE_PORTAL,1"
          ];

          render = {
            direct_scanout = lib.mkDefault true;
            # new_rendering_scheduling = lib.mkDefault true;
          };

          misc = {
            vfr = lib.mkDefault false;
            vrr = lib.mkDefault false;
          };
        };
      };
    };
  };

  xdg = {
    configFile = {
      "uwsm/env-hyprland" = {
        text = ''
          export AQ_DRM_DEVICES="${AQ_DRM_DEVICES}"
          export WLR_DRM_DEVICES="${WLR_DRM_DEVICES}"
        '';
      };
    };
  };
}
