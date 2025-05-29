{ lib, ... }:
{
  boot = {
    kernelParams = [
      "spectre_v2=on"
      "spec_store_bypass_disable=on"
      "tsx=off"
      "tsx_async_abort=full,nosmt"
      "mds=full,nosmt"
      "l1tf=full,force"
      "nosmt=force"
      "kvm.nx_huge_pages=force"
      "pti=on"
      # "iommu=force"
      # "iommu.strict=1"
      # "iommu.passthrough=0"
      "efi=disable_early_pci_dma"
    ];
  };

  security = {
    allowSimultaneousMultithreading = lib.mkDefault true;
  };
}
