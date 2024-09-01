{ config, lib, ... }:
{
  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
    };

    supportedFilesystems = [ "zfs" ];

    loader = {
      grub = {
        zfsSupport = true;
        copyKernels = true;
      };
    };

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  services = {
    zfs = {
      autoScrub = {
        enable = true;
      };

      autoSnapshot = {
        enable = true;
      };
    };

    udev = {
      extraRules = ''
        KERNEL=="zd*", ENV{UDISKS_IGNORE}="1"
      '';
    };
  };
}
