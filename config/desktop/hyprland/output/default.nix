{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkDefault [ ",highrr,auto,auto" ];

          envd = [
            "WLR_DRM_DEVICES,$HOME/.config/hypr/card:$HOME/.config/hypr/otherCard"
            #"WLR_RENDERER,vulkan"

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

          misc = {
            vfr = lib.mkDefault false;
            vrr = lib.mkDefault false;

            no_direct_scanout = lib.mkDefault false;
          };
        };
      };
    };
  };
}
