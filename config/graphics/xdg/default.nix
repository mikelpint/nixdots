{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  inherit (inputs.hyprland.packages."${pkgs.system}")
    xdg-desktop-portal-hyprland
    ;
  inherit (inputs.hyprland.inputs.nixpkgs.legacyPackages."${pkgs.system}")
    mesa
    pkgsi686Linux
    ;
  inherit (pkgs)
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    ;

  extraPortals = [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-hyprland
  ];
in
{
  environment = {
    systemPackages = extraPortals;

    pathsToLink = lib.optionals config.home-manager.useUserPackages [
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

      wlr = {
        enable = true;
      };

      config = {
        common = {
          default = "*";
        };
      };

      inherit extraPortals;
    };
  };

  programs = {
    hyprland = {
      portalPackage = xdg-desktop-portal-hyprland;
    };
  };

  hardware = {
    graphics = {
      package = mesa;

      package32 = pkgsi686Linux.mesa;
    };
  };
}
