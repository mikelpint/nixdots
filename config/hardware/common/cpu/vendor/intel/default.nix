{ config, lib, ... }:
{
  imports = [
    ../../isa/x86_64
    ./sgx
  ];

  hardware = {
    cpu = {
      intel = {
        updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  boot = {
    kernelModules = [ "kvm_intel" ];
    kernelParams = [ "intel_iommu=force_isolation" ];
  };
}
