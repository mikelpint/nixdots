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

    supportedFilesystems = {
      zfs = lib.mkDefault true;
    };

    initrd = {
      supportedFilesystems = {
        inherit (config.boot.supportedFilesystems) zfs;
      };
    };

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

      zed = {
        enableMail = false;

        settings = {
          ZED_DEBUG_LOG = "/tmp/zed.debug.log";
          ZED_EMAIL_ADDR = [ "root" ];
          ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
          ZED_EMAIL_OPTS = "@ADDRESS@";

          ZED_NOTIFY_INTERVAL_SECS = 3600;
          ZED_NOTIFY_VERBOSE = true;

          ZED_USE_ENCLOSURE_LEDS = true;
          ZED_SCRUB_AFTER_RESILVER = true;
        };
      };
    };

    udev = {
      extraRules = ''
        KERNEL=="zd*", ENV{UDISKS_IGNORE}="1"
      '';
    };
  };
}
