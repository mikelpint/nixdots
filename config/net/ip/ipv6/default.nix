{ config, lib, ... }:
{
  networking = {
    enableIPv6 = lib.mkDefault true;
  };

  boot = {
    kernelParams = [ "ipv6.disable=${if (config.networking.enableIPv6 or false) then "0" else "1"}" ];

    kernel = {
      sysctl = {
        "net.ipv6.conf.all.forwarding" = lib.mkDefault "0";
        "net.ipv6.conf.default.forwarding" = lib.mkDefault "0";
        "net.ipv6.conf.all.accept_ra" = "0";
        "net.ipv6.conf.all.accept_redirects" = lib.mkOverride 900 "0";
        "net.ipv6.conf.all.accept_source_route" = "0";
        "net.ipv6.conf.default.accept_redirects" = lib.mkOverride 900 "0";
        "net.ipv6.conf.default.accept_source_route" = "0";
        "net.ipv6.default.accept_ra" = "0";
        "net.ipv6.conf.default.router_solicitations" = "0";
        "net.ipv6.conf.all.router_solicitations" = "0";
        "net.ipv6.conf.default.accept_ra_rtr_pref" = "0";
        "net.ipv6.conf.all.accept_ra_rtr_pref" = "0";
        "net.ipv6.conf.default.accept_ra_pinfo" = "0";
        "net.ipv6.conf.all.accept_ra_pinfo" = "0";
        "net.ipv6.conf.default.accept_ra_defrtr" = "0";
        "net.ipv6.conf.all.accept_ra_defrtr" = "0";
        "net.ipv6.conf.default.autoconf" = "0";
        "net.ipv6.conf.all.autoconf" = "0";
        "net.ipv6.conf.default.dad_transmits" = "0";
        "net.ipv6.conf.all.dad_transmits" = "0";
        "net.ipv6.conf.default.max_addresses" = "1";
        "net.ipv6.conf.all.max_addresses" = "1";
        "net.ipv6.conf.default.use_tempaddr" = lib.mkOverride 900 "2";
        "net.ipv6.conf.all.use_tempaddr" = lib.mkOverride 900 "2";
        "net.ipv6.icmp.echo_ignore_all" = "1";
        "net.ipv6.icmp.echo_ignore_anycast" = "1";
        "net.ipv6.icmp.echo_ignore_multicast" = "1";
      };
    };
  };

  services = {
    clatd = {
      enable = config.networking.enableIPv6 or false;
    };
  };
}
