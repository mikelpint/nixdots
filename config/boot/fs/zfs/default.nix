_: {
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
