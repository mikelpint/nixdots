{
  networking = {
    nftables = {
      enable = true;
    };

    firewall = {
      enable = true;
      trustedInterfaces = [ ];

      logRefusedPackets = false;
      logRefusedConnections = true;

      allowPing = false;
      pingLimit = "2/minute burst 5 packets";

      allowedTCPPorts = [
        80
        443
      ];

      filterForward = false;
    };
  };
}
