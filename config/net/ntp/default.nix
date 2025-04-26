{ pkgs, config, ... }:
{
  networking = {
    timeServers = [
      "pool.ntp.org"

      "0.es.pool.ntp.org"
      "1.es.pool.ntp.org"
      "2.es.pool.ntp.org"
      "3.es.pool.ntp.org"

      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };

  services = {
    timesyncd = {
      enable = !config.services.chrony.enable;
    };

    chrony = {
      enable = true;

      extraFlags = [
        "-F 1"
        "-r"
      ];
      servers = [ ];
      enableRTCTrimming = false;
      initstepslew = {
        enabled = false;
      };

      extraConfig = ''
        # https://github.com/GrapheneOS/infrastructure/blob/b20cf862a315b4f55a7796351130f615453fe88b/etc/chrony.conf

        server time.cloudflare.com iburst nts
        server ntppool1.time.nl iburst nts
        server nts.netnod.se iburst nts
        server ptbtime1.ptb.de iburst nts
        server time.dfm.dk iburst nts
        server time.cifelli.xyz iburst nts

        minsources 3
        authselectmode require

        # EF
        dscp 46

        driftfile /var/lib/chrony/drift
        dumpdir /var/lib/chrony
        ntsdumpdir /var/lib/chrony

        leapseclist ${pkgs.tzdata}/share/zoneinfo/leap-seconds.list
        makestep 1.0 3

        rtconutc
        rtcsync

        cmdport 0

        noclientlog
      '';
    };
  };
}
