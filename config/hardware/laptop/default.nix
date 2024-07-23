# ASUS ROG Strix G15 G513IH-HN008

{
  imports = [
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
