{ config, user, ... }: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = false;
    };
  };

  services = {
    seatd = {
      enable = true;
      logLevel = "info";

      inherit user;
      group = "seat";
    };
  };

  users = {
    users = { "${user}" = { extraGroups = [ config.services.seatd.group ]; }; };
  };

  environment = { sessionVariables = { LIBSEAT_BACKEND = "logind"; }; };
}
