{ user, config, ... }:
let
  inherit (config.users.users.${user}) group;
in
{
  systemd = {
    tmpfiles = {
      settings = {
        # "restrictetcnixos" = {
        #   "/etc/nixos/*" = {
        #     Z = {
        #       mode = "0000";
        #       user = "root";
        #       group = "root";
        #     };
        #   };
        # };

        "restricthome" = {
          "/home/${user}" = {
            Z = {
              mode = "~0700";
              inherit user;
              inherit group;
            };
          };

          "/home/*" = {
            Z = {
              mode = "~0700";
            };
          };
        };
      };
    };
  };
}
