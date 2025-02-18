{ config, lib, ... }:

{
  imports = [ ../../common/bluetooth ];

  boot = {
    blacklistedKernelModules =
      lib.optionals (!config.hardware.enableRedistributableFirmware)
      [ "ath3k" ];
  };

  hardware = { bluetooth = { powerOnBoot = false; }; };
}
