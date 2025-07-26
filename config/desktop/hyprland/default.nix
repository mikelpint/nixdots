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
      enable = true;
      withUWSM = false;
      portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    };
  };

  services = lib.mkIf config.programs.hyprland.enable {
    seatd = {
      enable = true;
      logLevel = "info";

      inherit user;
      group = "seat";
    };

    greetd =
      let
        command =
          if config.programs.hyprland.withUWSM then
            ''
              [ $(${pkgs.uwsm}/bin/uwsm check may-start) ] && \
              ${pkgs.uwsm}/bin/uwsm start hyprland.desktop
            ''
          else
            "${config.services.dbus.dbusPackage}/bin/dbus-run-session Hyprland &> /dev/null";
      in
      {
        settings = {
          default_session = { inherit command; };
          initial_session = { inherit command; };
        };
      };
  };

  users = lib.mkIf config.programs.hyprland.enable {
    users = {
      "${user}" = {
        extraGroups = [ config.services.seatd.group ];
      };
    };
  };

  environment = lib.mkIf config.programs.hyprland.enable {
    sessionVariables = {
      LIBSEAT_BACKEND = "logind";
    };
  };

  nix = lib.mkIf config.programs.hyprland.enable {
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
