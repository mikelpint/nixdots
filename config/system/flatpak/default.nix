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

  users = lib.mkIf config.services.flatpak.enable {
    users = {
      ${user} = {
        extraGroups = [ "flatpak" ];
      };
    };
  };
}
