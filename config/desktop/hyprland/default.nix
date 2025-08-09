{
  config,
  user,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  programs = {
    hyprland = {
      enable = lib.mkDefault true;
      withUWSM = lib.mkDefault false;
      portalPackage = (inputs.hyprland.packages."${pkgs.system}" or pkgs).xdg-desktop-portal-hyprland;
    };
  };

  services = lib.mkIf (config.programs.hyprland.enable or false) {
    seatd = {
      enable = true;
      logLevel = "info";

      inherit user;
      group = "seat";
    };

    greetd =
      let
        command =
          if (config.programs.hyprland.withUWSM or false) then
            ''
              [ $(${pkgs.uwsm}/bin/uwsm check may-start) ] && \
              ${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop
            ''
          else
            "${config.services.dbus.dbusPackage or pkgs.dbus}/bin/dbus-run-session Hyprland";
        # "LD_LIBRARY_PATH=\"\" ${
        # config.services.dbus.dbusPackage or pkgs.dbus
        # }/bin/dbus-run-session Hyprland &> /dev/null";
      in
      {
        settings = {
          default_session = { inherit command; };
          initial_session = { inherit command; };
        };
      };
  };

  users = lib.mkIf (config.programs.hyprland.enable or false) {
    users = {
      "${user}" = {
        extraGroups = [ config.services.seatd.group or "seat" ];
      };
    };
  };

  environment = lib.mkIf (config.programs.hyprland.enable or false) {
    sessionVariables = {
      LIBSEAT_BACKEND = "logind";
    };
  };

  nix = lib.mkIf (config.programs.hyprland.enable or false) {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
