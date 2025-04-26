{ config, ... }:
{
  security = {
    pam = {
      services = {
        login = {
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
