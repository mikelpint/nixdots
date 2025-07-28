{ config, ... }:
{
  security = {
    pam = {
      services = {
        passwd = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable or false;
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
