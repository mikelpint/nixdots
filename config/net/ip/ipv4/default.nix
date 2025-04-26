{ lib, ... }:
{
  boot = {
    kernel = {
      sysctl = {
        "net.ipv4.tcp_window_scaling" = "0";
        "net.ipv4.tcp_timestamps" = "0";
        "net.ipv4.ip_forward" = lib.mkDefault "0";
        "net.ipv4.conf.all.forwarding" = lib.mkOverride 900 "0";
        "net.ipv4.conf.default.forwarding" = lib.mkDefault "0";
        "net.ipv4.conf.all.accept_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.conf.all.accept_source_route" = "0";
        "net.ipv4.conf.all.rp_filter" = lib.mkOverride 900 "1";
        "net.ipv4.conf.all.secure_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.conf.all.send_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.conf.default.accept_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.conf.default.accept_source_route" = "0";
        "net.ipv4.conf.default.rp_filter" = lib.mkOverride 900 "1";
        "net.ipv4.conf.default.secure_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.conf.default.send_redirects" = lib.mkOverride 900 "0";
        "net.ipv4.icmp_echo_ignore_all" = "1";
        "net.ipv4.tcp_dsack" = "0";
        "net.ipv4.tcp_fack" = "0";
        "net.ipv4.tcp_rfc1337" = "1";
        "net.ipv4.tcp_sack" = "0";
        "net.ipv4.tcp_syncookies" = "1";
        "net.ipv4.icmp_ignore_bogus_error_responses" = "1";
        "net.ipv4.conf.default.log_martians" = lib.mkOverride 900 "1";
        "net.ipv4.conf.all.log_martians" = lib.mkOverride 900 "1";
        "net.ipv4.conf.default.shared_media" = "0";
        "net.ipv4.conf.all.shared_media" = "0";
        "net.ipv4.conf.default.arp_announce" = "2";
        "net.ipv4.conf.all.arp_announce" = "2";
        "net.ipv4.conf.default.arp_ignore" = "1";
        "net.ipv4.conf.all.arp_ignore" = "1";
        "net.ipv4.conf.default.drop_gratuitous_arp" = "1";
        "net.ipv4.conf.all.drop_gratuitous_arp" = "1";
        "net.ipv4.icmp_echo_ignore_broadcasts" = lib.mkOverride 900 "1";
      };
    };
  };
}
