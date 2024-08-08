{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      with libsForQt5;
      with kdePackages; [
        qt5ct
        qt5.qtwayland

        qt6ct
        qtwayland
      ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          envd = [
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "QT_QPA_PLATFORMTHEME,qt6ct"
          ];
        };
      };
    };
  };
}
