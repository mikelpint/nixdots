_: {
  imports = [
    ./cpu
    ./display
    ./gpu
    ./input
    ./output
    ./storage
    ./usb
  ];

  hardware = {
    enableAllFirmware = true;
  };
}
