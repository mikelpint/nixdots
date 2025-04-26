{
  boot = {
    loader = {
      grub = {
        efiSupport = true;
      };

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    kernelParams = [ "efi=disable_early_pci_dma" ];
  };
}
