{
  systemd = {
    network = {
      links = {
        "10-wifi" = {
          matchConfig = {
            MACAddress = "40:74:e0:76:f4:b2";
          };
          linkConfig = {
            Name = "wifi";
          };
        };
      };

      networks = {
        wifi = {
          enable = true;

          addresses = [ { Address = "192.168.1.104/24"; } ];
        };
      };
    };
  };
}
