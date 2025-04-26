{ lib, ... }:
{
  imports = [
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./output
    ./storage
    ./usb
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = lib.mkDefault true;
  };
}
