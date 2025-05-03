{ config, ... }:
{
  security = {
    pam = {
      services = {
        hyprlock = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable;
          text = "\n            auth include login\n          ";
        };
      };
    };
  };
}
