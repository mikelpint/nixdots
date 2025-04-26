{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_13;

    zfs = {
      # package = config.boot.kernelPackages.zfs_unstable;
      package = pkgs.zfs_unstable;

      removeLinuxDRM = false;
    };

    initrd = {
      supportedFilesystems = [ "zfs" ];
    };

    supportedFilesystems = [ "zfs" ];

    loader = {
      grub = {
        zfsSupport = true;
        zfsPackage = lib.mkForce config.boot.zfs.package;

        copyKernels = true;
      };
    };
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
