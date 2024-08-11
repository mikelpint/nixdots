_: {
  imports = [
    ./cpu
    ./display
    ./gpu
    ./storage
    ./usb
  ];

  hardware = {
    enableAllFirmware = true;
  };
}
