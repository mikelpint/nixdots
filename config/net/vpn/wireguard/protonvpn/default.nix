{
  config,
  lib,
  self,
  pkgs,
  ...
}:

let
  listenPort = 51820;

  interfaces = {
    wg-proton-fr-196 = {
      # Bouncing = 14

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-fr-196".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "m8vo9+NTxgkGJ1eV2nP9AyanXxeSlztAhIhQWDYPfnc=";
          endpoint = "149.102.245.129:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };

    wg-proton-es-88 = {
      # Bouncing = 0
      # NetShield = 1
      # Moderate NAT = off
      # NAT-PMP (Port Forwarding) = off
      # VPN Accelerator = on

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-es-88".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "tEz96jcHEtBtZOmwMK7Derw0AOih8usKFM+n4Svhr1E=";
          endpoint = "130.195.250.66:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };

    wg-proton-gr-1 = {
      # Bouncing = 5
      # NetShield = 1
      # Moderate NAT = off
      # NAT-PMP (Port Forwarding) = off
      # VPN Accelerator = on

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-gr-1".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "DTaJG0Ww2G2Gtv7GVlkiOIv9cv8r9yQ0ghNPQf7kDAw=";
          endpoint = "185.51.134.194:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };

    wg-proton-uk-400 = {
      # Bouncing = 11
      # NetShield = 1
      # Moderate NAT = off
      # NAT-PMP (Port Forwarding) = off
      # VPN Accelerator = on

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-uk-400".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "WbRD+D0sEqI7tlTIycY4QVlSgv3zPWCWmx0Z+UA08gI=";
          endpoint = "146.70.179.34:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };

    wg-proton-us-ny-175 = {
      # Bouncing = 9
      # NetShield = 1
      # Moderate NAT = on
      # NAT-PMP (Port Forwarding) = on
      # VPN Accelerator = on

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-us-ny-175".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "siQYYgaXYcbz1W0fR0Tpq6ExLLggu/xCOdDOfitDexM=";
          endpoint = "146.70.179.34:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };

    wg-proton-de-200 = {
      # Bouncing = 14
      # NetShield = 1
      # Moderate NAT = off
      # NAT-PMP (Port Forwarding) = off
      # VPN Accelerator = on

      autostart = false;

      privateKeyFile = config.age.secrets."wg-proton-de-200".path;
      address = [ "10.2.0.2/32" ];
      dns = [ "10.2.0.1" ];

      peers = [
        {
          publicKey = "MOLPnnM2MSq7s7KqAgpm+AWpmzFAtuE46qBFHeLg5Tk=";
          endpoint = "217.138.216.130:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
        }
      ];
    };
  };
in
{
  age = {
    secrets = builtins.mapAttrs (name: value: {
      rekeyFile = "${self}/secrets/${name}.age";
    }) interfaces;
  };

  networking = {
    enableIPv6 = lib.mkForce true;

    firewall = {
      allowedUDPPorts = [ listenPort ];
    };

    wg-quick = {
      interfaces = builtins.mapAttrs (
        name: value:
        value
        // {
          inherit listenPort;

          postUp =
            lib.lists.foldr
              (a: b: ''
                ${a}
                ${b}
              '')
              ""
              (
                builtins.map (x: ''
                  ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
                  ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
                '') value.address
              );

          preDown =
            lib.lists.foldr
              (a: b: ''
                ${a}
                ${b}
              '')
              ""
              (
                builtins.map (x: ''
                  ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
                  ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
                '') value.address
              );
        }
      ) interfaces;
    };

    /*
      wireguard = {
        interfaces = builtins.mapAttrs (name: value: {
          inherit listenPort;
          privateKeyFile = value.privateKeyFile;
          ips = value.address;
          peers = value.peers;
        }) interfaces;
      };
    */
  };
}
