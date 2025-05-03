{ lib, ... }:
{
  boot = {
    loader = {
      grub = {
        efiSupport = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = lib.mkDefault "/boot";
      };
    };

    kernelParams = [ "efi=disable_early_pci_dma" ];
  };
}
