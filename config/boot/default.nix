{ config, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    extraModprobeConfig = "options kvm_intel nested=1";

    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

    supportedFilesystems = [ "btrfs" ];

    loader = {
      systemd-boot = {
        enable = false;
        editor = false;
      };

      timeout = 5;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;
      };

      #grub2-theme = {
      #  enable = true;
      #  icon = "white";
      #  theme = "whitesur";
      #  screen = "1080p";
      #  splashImage = ../../backgrounds/grub.jpg;
      #  footer = true;
      #};
    };
  };
}
