{
  networking = { networkmanager = { enable = true; }; };

  services = { NetworkManager-wait-online = { enable = true; }; };
}
