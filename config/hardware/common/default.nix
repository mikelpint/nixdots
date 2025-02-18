{ lib, ... }: {
  imports = [ ./cpu ./display ./gpu ./input ./output ./storage ./usb ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = lib.mkDefault true;
  };
}
