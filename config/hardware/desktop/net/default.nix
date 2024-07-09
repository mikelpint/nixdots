{
  networking = { hostName = "desktopmikel"; };
  boot = {
    kernel = {
      sysctl = {
        "net.ipv4.tcp_fin_timeout" = 5;

        "net.ipv4.tcp_keepalive_time" = 60;
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;

        "net.ipv4.tcp_fastopen" = 3;

        "net.core.netdev_max_backlog" = 16384;

        "net.core.rmem_default" = 1048576;
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_default" = 1048576;
        "net.core.wmem_max" = 16777216;
        "net.core.optmem_max" = 65536;

        "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
        "net.ipv4.tcp_wmem" = "4096 65536 16777216";

        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
        "net.ipv4.udp_mem" = "65536 131072 262144";
      };
    };
  };
}
