{
  pkgs,
  config,
  lib,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      with libsForQt5;
      with kdePackages;
      [
        qt5ct
        qt5.qtwayland

        qt6ct
        qtwayland
      ];

    sessionVariables = {
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    };
  };

  qt = {
    style = {
      package = with pkgs; [
        darkly-qt5
        darkly
      ];
    };

    platformTheme = {
      name = "qtct";
    };
  };

  xdg =
    let
      inherit
        (config.catppuccin or {
          enable = false;
          flavor = "mocha";
          accent = "mauve";
        }
        )
        enable
        flavor
        accent
        ;
    in
    lib.mkIf enable {
      configFile =
        let
          source = "${
            pkgs.fetchFromGitHub {
              owner = "catppuccin";
              repo = "qt5ct";
              rev = "cb585307edebccf74b8ae8f66ea14f21e6666535";
              sha256 = "wDj6kQ2LQyMuEvTQP6NifYFdsDLT+fMCe3Fxr8S783w=";
            }
          }/catppuccin-${flavor}-${accent}.conf";
        in
        {
          "qt5ct/colors/catppuccin-${flavor}-${accent}.conf" = { inherit source; };
          "qt6ct/colors/catppuccin-${flavor}-${accent}.conf" = { inherit source; };
        };
    };
}
