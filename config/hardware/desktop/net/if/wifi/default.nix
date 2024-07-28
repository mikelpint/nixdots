{
  systemd = {
    network = {
      links = {
        "10-wifi" = {
          matchConfig = { MACAddress = "40:74:e0:76:f4:b2"; };
          linkConfig = { Name = "wifi"; };
        };
      };
    };
  };

  networking = {
    interfaces = {
      wifi = {
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
