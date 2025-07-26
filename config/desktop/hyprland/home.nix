{
  lib,
  inputs,
  pkgs,
  config,
  osConfig,
  user,
  ...
}:

let
  imports = [
    ./apps/home.nix
    ./bar/home.nix
    ./binds/home.nix
    ./clipboard/home.nix
    ./cursor/home.nix
    ./debug/home.nix
    ./decoration/home.nix
    ./font/home.nix
    ./gestures/home.nix
    ./gtk/home.nix
    ./icons/home.nix
    ./idle/home.nix
    ./input/home.nix
    ./layout/home.nix
    ./lock/home.nix
    ./notifications/home.nix
    ./opacity/home.nix
    ./output/home.nix
    ./ozone/home.nix
    ./plugins/home.nix
    ./polkit/home.nix
    ./qt/home.nix
    ./scripts/home.nix
    ./systemd/home.nix
    ./theme/home.nix
    ./wallpaper/home.nix
    ./xwayland/home.nix
  ];
in
{
  inherit imports;

  home = {
    sessionVariables = {
      WAYLAND_DISPLAY = 1;
    };
  };

  wayland = {
    windowManager = {
      hyprland = {
        enable = true;

        package = inputs.hyprland.packages."${pkgs.system}".hyprland.override {
          withSystemd = config.wayland.windowManager.hyprland.systemd.enable;

          legacyRenderer = false;

          enableXWayland = config.wayland.windowManager.hyprland.xwayland.enable;
        };

        settings =
          let
            args = {
              inherit config;
              inherit inputs;
              inherit lib;
              inherit osConfig;
              inherit pkgs;
              inherit user;
            };
          in
          {
            exec-once = lib.mkForce (
              lib.lists.sort
                (
                  a: _b:
                  !(builtins.elem a ((import ./bar/home.nix) args).wayland.windowManager.hyprland.settings.exec-once)
                )
                (
                  lib.lists.flatten (
                    builtins.map (x: x.wayland.windowManager.hyprland.settings.exec-once or [ "a" ]) (
                      builtins.filter (x: x ? wayland.windowManager.hyprland.settings.exec-once) (
                        builtins.map (x: if builtins.isFunction x then x args else x) (builtins.map import imports)
                      )
                    )
                  )
                )
            );

            envd = [ "TERM,xdg-terminal-exec" ];

            misc = {
              disable_autoreload = lib.mkDefault false;

              disable_splash_rendering = true;
              disable_hyprland_logo = true;
              force_default_wallpaper = 0;
            };

            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
              enforce_permissions = false;
            };
          };
      };
    };
  };
}
