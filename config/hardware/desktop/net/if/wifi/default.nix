{
  systemd = {
    network = {
      links = {
        "10-wifi" = {
          matchConfig = { Name = "wlp7s0"; };
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
