{ config, lib, ... }:
{
  imports = [
    ../../isa/x86_64
    ./sev
    ./smu
  ];

  hardware = {
    cpu = {
      amd = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  boot = {
    kernelModules = [ "kvm_amd" ];
    kernelParams = [ "amd_iommu=force_isolation" ];
  };
}
