{ inputs, pkgs, lib, config, ... }:
let
  inherit (inputs.nixpkgs-small.legacyPackages."${pkgs.system}")
    xdg-desktop-portal-hyprland;
  inherit (pkgs)
    xdg-desktop-portal xdg-desktop-portal-wlr xdg-desktop-portal-gtk;

  extraPortals = [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
in {
  environment = {
    systemPackages = extraPortals;

    pathsToLink = lib.optionals config.home-manager.useUserPackages [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
  };

  xdg = {
    autostart = { enable = true; };

    portal = {
      enable = true;
      xdgOpenUsePortal = true;

      wlr = { enable = true; };

      config = { common = { default = "*"; }; };

      inherit extraPortals;
    };
  };

  programs = { hyprland = { portalPackage = xdg-desktop-portal-hyprland; }; };
}
