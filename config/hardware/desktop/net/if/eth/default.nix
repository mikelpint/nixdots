{
  systemd = {
    network = {
      links = {
        "10-eth" = {
          matchConfig = { MACAddress = "04:d9:f5:d2:4f:bf"; };
          linkConfig = { Name = "eth"; };
        };
      };
    };
  };

  networking = {
    interfaces = {
      eth = {
        ipv4 = {
          addresses = [{
            address = "192.168.1.104";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
