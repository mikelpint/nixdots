{lib, ...}: {
    boot = {
      kernelParams = [
        "mitigations=auto"
        "pti=on"
        "iommu=force"
        "iommu.strict=1"
        "iommu.passthrough=0"
      ];
    };

    security = {
        allowSimultaneousMultithreading = lib.mkDefault true;
    };
}
