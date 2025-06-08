{ lib, ... }:
{
  imports = [
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./output
    ./power
    ./storage
    ./usb
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = lib.mkDefault true;
  };
}
