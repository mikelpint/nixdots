{
  systemd = {
    network = {
      links = {
        "10-wifi" = {
          matchConfig = {
            Name = "wlp3s0";
          };
          linkConfig = {
            Name = "wifi";
          };
        };
      };
    };
  };
}
