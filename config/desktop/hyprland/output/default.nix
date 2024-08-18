{ lib, ... }:
{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkDefault [ ",highrr,auto,auto" ];

          envd = [
            "WLR_DRM_DEVICES,$HOME/.config/hypr/card"

            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"

            "GDK_BACKEND,wayland,x11"
            "QT_QPA_PLATFORM,wayland;xcb"
            "CLUTTER_BACKEND,wayland"
            "SDL_VIDEODRIVER,wayland"

            "_JAVA_AWT_WM_NONREPARENTING,1"

            "GTK_USE_PORTAL,1"
            "NIXOS_XDG_OPEN_USE_PORTAL,1"
          ];

          render = {
            explicit_sync = lib.mkDefault 1;
            explicit_sync_kms = lib.mkDefault 1;

            direct_scanout = lib.mkDefault true;
          };

          misc = {
            vfr = lib.mkDefault false;
            vrr = lib.mkDefault false;
          };
        };
      };
    };
  };
}
