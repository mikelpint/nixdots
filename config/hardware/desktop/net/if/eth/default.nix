{
  systemd = {
    network = {
      links = {
        "10-eth" = {
          matchConfig = {
            MACAddress = "04:d9:f5:d2:4f:bf";
          };

          linkConfig = {
            Name = "eth";
          };
        };
      };

      networks = {
        eth = {
          enable = false;

          addresses = [ { Address = "192.168.1.104/24"; } ];
        };
      };
    };
  };
}
