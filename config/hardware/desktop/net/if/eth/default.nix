{
  systemd = {
    network = {
      links = {
        "10-eth" = {
          matchConfig = { Name = "enp8s0"; };
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
