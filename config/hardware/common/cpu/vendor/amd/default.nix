{ config, lib, ... }: {
  imports = [ ../iso/x86_64 ./sev ];

  hardware = {
    cpu = {
      amd = {
        updateMicrocode =
          lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  boot = { kernelModules = [ "kvm_amd" ]; };
}
