{
  user,
  lib,
  config,
  ...
}:
{
  services = {
    printing = {
      enable = lib.mkDefault true;
    };

    avahi = {
      enable = lib.mkDefault config.services.printing.enable;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  users = lib.mkIf config.services.printing.enable {
    users = {
      "${user}" = {
        extraGroups = [
          "lp"
          "lpadmin"
          "scanner"
        ];
      };
    };
  };
}
