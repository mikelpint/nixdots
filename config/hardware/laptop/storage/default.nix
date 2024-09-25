{ self, lib, ... }:

{
  imports = [
    ./hdd
    ./ssd

    ../../../boot/luks
    ../../../boot/fs/btrfs
  ];

  age = {
    secrets = {
      luks-passwd = {
        rekeyFile = "${self}/secrets/luks-passwd.age";
      };
    };
  };

  boot = {
    kernelParams = [ "resume_offset=269568" ];
    resumeDevice = "/dev/disk/by-label/nixos";

    initrd = {
      luks = {
        devices = {
          crypt = {
            device = lib.mkForce "/dev/disk/by-label/nixos";
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
    "/var/log" = {
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
