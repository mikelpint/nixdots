{ config, ... }:
{
  security = {
    pam = {
      services = {
        su = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable or false;

          requireWheel = true;
        };

        su-l = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable or false;

          requireWheel = true;
        };
      };
    };
  };
}
