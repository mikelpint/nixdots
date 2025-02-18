{
  systemd = {
    network = {
      links = {
        "10-wifi" = {
          matchConfig = { MACAddress = "ec:2e:98:d4:01:29"; };

          linkConfig = { Name = "wifi"; };
        };
      };
    };
  };
}
