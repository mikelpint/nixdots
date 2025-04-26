{
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          envd = [
            "NIXOS_OZONE_WL,1"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
          ];
        };
      };
    };
  };

  xdg = {
    configFile = {
      "electron-flags.conf" = {
        text = ''
          --enable-features=UseOzonePlatform
          --ozone-platform=wayland
        '';
      };
    };
  };
}
