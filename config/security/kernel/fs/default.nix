{
  boot = {
    kernel = {
      sysctl = {
        "fs.protected_fifos" = "2";
        "fs.protected_hardlinks" = "1";
        "fs.protected_regular" = "2";
        "fs.protected_symlinks" = "1";
        "fs.suid_dumpable" = "0";
      };
    };

    specialFileSystems = {
      "/dev/shm" = {
        options = [ "noexec" ];
      };

      "/run" = {
        options = [ "noexec" ];
      };

      "/dev" = {
        options = [ "noexec" ];
      };
    };
  };
}
