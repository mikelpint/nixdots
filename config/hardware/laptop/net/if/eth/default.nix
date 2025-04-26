{
  systemd = {
    network = {
      links = {
        "10-eth" = {
          matchConfig = {
            MACAddress = "7c:10:c9:25:5d:f4";
          };

          linkConfig = {
            Name = "eth";
          };
        };
      };
    };
  };
}
