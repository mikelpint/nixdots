{ lib, ... }:
{
  imports = [ ./memtest86 ];

  boot = {
    loader = {
      grub = {
        enable = lib.mkDefault true;
        device = lib.mkDefault "nodev";

        useOSProber = lib.mkDefault true;

        configurationLimit = lib.mkDefault 5;

        efiSupport = true;
        efiInstallAsRemovable = lib.mkDefault false;
        gfxmodeEfi = lib.mkDefault "auto";
        gfxpayloadEfi = lib.mkDefault "keep";
      };
    };
  };

  catppuccin = {
    grub = {
      enable = true;
      flavor = "macchiato";
    };
  };
}
