{ lib, user, ... }:

let
  device = "/dev/disk/by-uuid/2701f7fd-4969-40f3-a930-f7b0e52fef48";
  fsType = "btrfs";
  options = subvol: [
    "compress=zstd:3"
    "noatime"
    "ssd"
    "space_cache=v2"
    "commit=120"
    "subvol=${subvol}"
  ];
in
{
  imports = [
    ./hdd
    ./ssd

    ../../../boot/luks
    ../../../boot/fs/btrfs
  ];

  boot = {
    kernelParams = [ "resume_offset=269568" ];
    resumeDevice = device;

    initrd = {
      luks = {
        devices = {
          crypt = {
            device = lib.mkForce "/dev/disk/by-uuid/50869e25-ac4e-487e-a471-faae5d57626e";
          };
        };
      };
    };
  };

  services = {
    gvfs = {
      enable = true;
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/41A4-CA82";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    "/" = {
      inherit device;
      inherit fsType;
      options = options "root";
    };

    "/home/${user}" = {
      inherit device;
      inherit fsType;
      options = options user;
    };

    "/nix" = {
      inherit device;
      inherit fsType;
      options = options "nix";
    };

    "/swap" = {
      inherit device;
      inherit fsType;
      options = options "swap";
    };

    "/tmp" = {
      inherit device;
      inherit fsType;
      options = options "tmp";
    };

    "/var/log" = {
      inherit device;
      inherit fsType;
      options = options "log";
      neededForBoot = true;
    };

    "/mnt/WD_Black" = {
      device = "/dev/disk/by-uuid/1611231c-401a-4e80-8cac-1d09ab54454b";
      fsType = "ext4";
      options = [
        "rw"
        "users"
        "nofail"
        "rw"
        "exec"
        "x-gvfs-show"
      ];
    };
  };
}
