# ASUS ROG Strix G15 G513IH-HN008

_: {
  imports = [
    ../common

    ../../boot/secureboot

    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./net
    ./output
    ./power
    ./storage
    ./usb
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
