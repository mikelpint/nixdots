{
  boot = { kernel = { sysctl = { "net.netfilter.nf_log_all_netns" = 1; }; }; };

  networking = {
    nftables = {
      enable = true;
      flushRuleset = true;

      tables = {
        traceall = {
          enable = true;

          name = "traceall";
          family = "ip";

          content = ''
            chain prerouting {
                type filter hook prerouting priority -350; policy accept;
                meta nftrace set 1
            }

            chain output {
                type filter hook output priority -350; policy accept;
                meta nftrace set 1
            }
          '';
        };
      };
    };

    firewall = {
      enable = true;
      trustedInterfaces = [ ];

      logRefusedPackets = false;
      logRefusedConnections = true;
      logReversePathDrops = false;
      logRefusedUnicastsOnly = true;

      allowPing = false;
      pingLimit = "2/minute burst 5 packets";

      allowedTCPPorts = [ 80 443 53 ];
      allowedUDPPorts = [ 53 ];

      filterForward = true;

      rejectPackets = false;
    };
  };
}
