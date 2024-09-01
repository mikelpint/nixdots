{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:

let
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
in
{
  inherit imports;

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;

        package = (
          inputs.hyprland.packages."${pkgs.system}".hyprland.override {
            withSystemd = config.wayland.windowManager.hyprland.systemd.enable;
            legacyRenderer = false;
            enableXWayland = config.wayland.windowManager.hyprland.xwayland.enable;
          }
        );

        settings = {
          exec-once = lib.mkForce (
            lib.lists.sort
              (
                a: b:
                !(builtins.elem a
                  ((import ./bar) { inherit pkgs; }).wayland.windowManager.hyprland.settings.exec-once
                )
              )
              (
                lib.lists.flatten (
                  builtins.map (x: x.wayland.windowManager.hyprland.settings.exec-once or [ "a" ]) (
                    builtins.filter (x: x ? wayland.windowManager.hyprland.settings.exec-once) (
                      builtins.map (
                        x:
                        if builtins.isFunction x then
                          x {
                            inherit pkgs;
                            inherit config;
                            inherit lib;
                            inherit inputs;
                          }
                        else
                          x
                      ) (builtins.map (x: import x) imports)
                    )
                  )
                )
              )
          );

          envd = [ "TERM,wezterm" ];

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
