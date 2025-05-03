{ config, ... }:
{
  security = {
    pam = {
      services = {
        passwd = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable;

          rules = {
            password = {
              "unix" = {
                settings = {
                  rounds = 65536;
                };
              };
            };
          };
        };
      };
    };
  };
}
