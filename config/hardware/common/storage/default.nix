{
  lib,
  user,
  config,
  ...
}:
{
  services = {
    hdapsd = {
      enable = lib.mkDefault false;
    };

    udisks2 = {
      enable = true;
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "sd_mod"
        "ahci"
      ];
    };

    kernelModules = [ "sg" ];
  };

  fileSystems = {
    "/mnt/WD_Black" = {
      device = "/dev/disk/by-uuid/1611231c-401a-4e80-8cac-1d09ab54454b";
      fsType = "ext4";
      noCheck = lib.mkDefault true;
      options = [
        "rw"
        "nofail"
        "noauto"
        "rw"
        "exec"
        "uid=${user}"
        "gid=${config.users.users.${user}.group}"
        "users"
        "x-gvfs-show"
        "x-systemd.automount"
      ];
    };
  };
}
