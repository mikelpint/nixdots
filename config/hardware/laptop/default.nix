# ASUS ROG Strix G15 G513IH-HN008

{
  import = [ ./bluetooth ./cpu ./gpu ./input ./power ./storage ];

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
