{
  networking = {
    networkmanager = {
      enable = true;

      wifi = { backend = "iwd"; };
    };
  };

  systemd = {
    services = { NetworkManager-wait-online = { enable = false; }; };
  };
}
