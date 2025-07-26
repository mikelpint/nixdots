{ lib, user, ... }:
{
  hardware = {
    cpu = {
      amd = {
        sev = {
          enable = lib.mkDefault true;

          user = "root";
          group = "sev";
        };
      };
    };
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "sev" ];
      };
    };
  };
}
