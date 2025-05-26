{ config, ... }:
{
  security = {
    pam = {
      services = {
        passwd = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable;
          allowNullPassword = true;

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
