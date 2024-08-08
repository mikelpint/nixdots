# ASUS ROG Strix G15 G513IH-HN008

_: {
  imports = [
    ../common
    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
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
