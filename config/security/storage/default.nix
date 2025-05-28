{ lib, config, ... }:
{
  fileSystems = {
    "/home" = {
      device = lib.mkDefault "/home";
      options = [
        "bind"
        "nosuid"
        "nodev"
      ];
    };

    "/root" = {
      device = lib.mkDefault "/root";
      options = [
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/tmp" = {
      device = lib.mkDefault "/tmp";
      options = [
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/var" = {
      device = lib.mkDefault "/var";
      options = [
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/boot" = lib.mkIf (!config.boot.isContainer) {
      options = [
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/srv" = {
      device = lib.mkDefault "/srv";
      options = [
        "bind"
        "nosuid"
        "noexec"
        "nodev"
      ];
    };

    "/etc" = lib.mkIf (!config.boot.isContainer) {
      device = lib.mkDefault "/etc";
      options = [
        "bind"
        "nosuid"
        "nodev"
      ];
    };
  };
}
