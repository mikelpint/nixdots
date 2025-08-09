{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (pkgs)
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    ;

  extraPortals = [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];
in
{
  environment = {
    systemPackages = extraPortals;

    pathsToLink = lib.optionals (config.home-manager.useUserPackages or false) [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };

  xdg = {
    autostart = {
      enable = true;
    };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      config = {
        common = {
          default = "*";
        };
      };

      inherit extraPortals;
    };
  };
}
