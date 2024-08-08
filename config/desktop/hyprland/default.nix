{ lib, inputs, pkgs, config, ... }: {
  imports = [
    ./apps
    ./bar
    ./binds
    ./cursor
    ./debug
    ./decoration
    ./font
    ./gestures
    ./gtk
    ./icons
    ./idle
    ./input
    ./layout
    ./lock
    ./notifications
    ./output
    ./ozone
    ./plugins
    ./polkit
    ./qt
    ./scripts
    ./systemd
    ./theme
    ./wallpaper
    ./xwayland
  ];

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;

        package = (inputs.hyprland.packages."${pkgs.system}".hyprland.override {
          withSystemd = config.wayland.windowManager.hyprland.systemd.enable;
          legacyRenderer = false;
          enableXWayland =
            config.wayland.windowManager.hyprland.xwayland.enable;
        });

        settings = {
          misc = {
            disable_autoreload = lib.mkDefault false;

            disable_splash_rendering = true;
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;
          };
        };
      };
    };
  };
}
