{
  config,
  user,
  lib,
  ...
}:
{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = false;
    };
  };

  services = lib.mkIf config.programs.hyprland.enable {
    seatd = {
      enable = true;
      logLevel = "info";

      inherit user;
      group = "seat";
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
