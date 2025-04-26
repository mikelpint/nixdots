{ lib, ... }:
{
  boot = {
    kernelParams = lib.mkDefault [
      "mitigations=auto"
      "pti=on"
      "iommu=force"
      "iommu.strict=1"
      "iommu.passthrough=0"
    ];
  };
}
