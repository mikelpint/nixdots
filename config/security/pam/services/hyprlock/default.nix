{ config, ... }:
{
  security = {
    pam = {
      services = {
        hyprlock = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable or false;
          text = "\n            auth include login\n          ";
        };
      };
    };
  };
}
