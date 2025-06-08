{ lib, ... }:
{
  boot = {
    kernel = {
      sysctl = {
        "net.netfilter.nf_log_all_netns" = 1;
      };
    };
  };

  networking = {
    nftables = {
      enable = true;
      flushRuleset = true;

      tables = {
        traceall = {
          enable = false;

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

      logRefusedPackets = true;
      logRefusedConnections = true;
      logReversePathDrops = true;
      logRefusedUnicastsOnly = true;

      allowPing = lib.mkDefault false;
      pingLimit = lib.mkDefault "2/minute burst 5 packets";

      allowedTCPPorts = [
        80
        443
        53
      ];
      allowedUDPPorts = [ 53 ];

      filterForward = lib.mkDefault true;

      rejectPackets = lib.mkDefault false;
    };
  };

  services = {
    ulogd = {
      enable = false;
      logLevel = 1;

      settings = {
        emu1 = {
          file = "/var/log/ulogd_pkts.log";
          sync = 1;
        };
        global = {
          stack = [
            "log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU"
            "log1:NFLOG,base1:BASE,pcap1:PCAP"
          ];
        };
        log1 = {
          group = 2;
        };
        pcap1 = {
          file = "/var/log/ulogd.pcap";
          sync = 1;
        };
      };
    };
  };
}
