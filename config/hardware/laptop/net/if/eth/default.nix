{
  systemd = {
    network = {
      links = {
        "10-eth" = {
          matchConfig = {
            Name = "enp2s0";
          };
          linkConfig = {
            Name = "eth";
          };
        };
      };
    };
  };
}
