{ lib, ... }:
{
  services = {
    hdapsd = {
      enable = lib.mkDefault false;
    };

    udisks2 = {
        enable = true;
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "sd_mod"
        "ahci"
      ];
    };

    kernelModules = [ "sg" ];
  };
}
