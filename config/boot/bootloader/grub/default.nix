{ lib, config, ... }:
{
  imports = [ ./memtest86 ];

  boot = {
    loader = {
      grub = {
        enable = lib.mkDefault false;
        device = lib.mkDefault "nodev";

        useOSProber = lib.mkDefault true;

        configurationLimit = lib.mkDefault 50;

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
      inherit (config.catppuccin) flavor;
    };
  };
}
