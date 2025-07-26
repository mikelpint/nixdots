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
    enableAllFirmware = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
    firmwareCompression = lib.mkDefault "zstd";
  };
}
