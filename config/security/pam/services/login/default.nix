{ config, ... }:
{
  security = {
    pam = {
      services = {
        login = {
          enable = true;
          enableAppArmor = config.security.apparmor.enable;
          enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;

          rules = {
            auth = {
              "nologin" = {
                enable = true;
                order = 0;
                control = "requisite";
                modulePath = "${config.security.pam.package}/lib/security/pam_nologin.so";
              };

              "securetty" = {
                enable = true;
                order = 1;
                control = "requisite";
                modulePath = "${config.security.pam.package}/lib/security/pam_securetty.so";
              };
            };
          };
        };
      };
    };
  };
}
