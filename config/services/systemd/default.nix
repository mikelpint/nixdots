{
  systemd = {
    services.NetworkManager-wait-online.enable = false;
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };
}
