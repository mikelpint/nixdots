{ user, ... }:
{
  imports = [
    ./hdd
    ./ssd

    ../../../boot/fs/btrfs
    ../../../boot/fs/zfs
  ];

  services = {
    gvfs = {
      enable = true;
    };
  };

  boot = {
    zfs = {
      extraPools = [ "zroot" ];
    };
  };

  systemd = {
    services = {
      zfs-mount = {
        enable = true;
      };
    };
  };

  fileSystems = {
    "zroot" = {
      device = "zroot";
      fsType = "zfs";
      options = [
        "noauto"
        "x-gvfs-hide"
      ];
    };

    "/" = {
      device = "zroot/system/root";
      fsType = "zfs";
    };

    "/home" = {
      device = "zroot/user/home";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/home/${user}" = {
      device = "zroot/user/home/${user}";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/libvirt" = {
      device = "zroot/libvirt";
      fsType = "zfs";
      options = [
        "defaults"
        "nofail"
      ];
    };

    "/nix" = {
      device = "zroot/system/nix";
      fsType = "zfs";
    };

    "/root" = {
      device = "zroot/user/home/root";
      fsType = "zfs";
    };

    "/tmp" = {
      device = "zroot/tmp";
      fsType = "zfs";
    };

    "/var" = {
      device = "zroot/system/var";
      fsType = "zfs";
    };

    "/mnt/XFS" = {
      device = "/dev/disk/by-uuid/217b2e5d-a5a7-4a50-8990-6addb8d71169";
      fsType = "xfs";
      options = [
        "rw"
        "users"
        "nofail"
        "x-gvfs-show"
      ];
    };

    "/mnt/Games" = {
      device = "/dev/disk/by-uuid/2c8e93e1-348e-4a88-8e6e-585c150e1312";
      fsType = "ext4";
      options = [
        "rw"
        "users"
        "nofail"
        "exec"
        "x-gvfs-show"
      ];
    };

    "/mnt/Shared_Games" = {
      device = "/dev/disk/by-uuid/811e6f89-1a61-4f8f-abcd-26e7f7936227";
      fsType = "btrfs";
      options = [
        "rw"
        "users"
        "nofail"
        "exec"
        "x-gvfs-show"
      ];
    };
  };
}
