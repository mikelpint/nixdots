{ config, ... }:
{
  security = {
    pam = {
      services = {
        system-login = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable or false;

          failDelay = {
            delay = "4000000";
          };
        };
      };
    };
  };
}
