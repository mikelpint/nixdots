{ lib, ... }: {
  imports = [ ./sev ];

  hardware = {
    cpu = {
      amd = {
        updateMicrocode =
          lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };
}
