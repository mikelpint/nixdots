# ASUS ROG Strix G15 G513IH-HN008

_: {
  imports = [
    ../common

    #../../boot/secureboot

    ./audio
    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./net
    ./power
    ./storage
  ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
