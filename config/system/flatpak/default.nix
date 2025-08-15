{
  config,
  lib,
  user,
  ...
}:
{
  services = {
    flatpak = {
      enable = true;
    };
  };

  users = lib.mkIf (config.services.flatpak.enable or false) {
    users = {
      ${user} = {
        extraGroups = [ "flatpak" ];
      };
    };
  };
}
