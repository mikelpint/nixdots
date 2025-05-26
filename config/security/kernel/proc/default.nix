{ config, ... }:
{
  users = {
    groups = {
      proc = {
        gid = config.ids.gids.proc;
      };
    };
  };

  systemd = {
    services = {
      systemd-logind = {
        serviceConfig = {
          SupplementaryGroups = [ "proc" ];
        };
      };

      "user@" = {
        serviceConfig = {
          SupplementaryGroups = [ "proc" ];
        };
      };
    };
  };

  boot = {
    specialFileSystems = {
      "/proc" = {
        device = "proc";
        options = [
          "nosuid"
          "nodev"
          "noexec"
          "hidepid=2"
          "gid=${toString config.users.groups.proc.gid}"
        ];
      };
    };
  };
}
