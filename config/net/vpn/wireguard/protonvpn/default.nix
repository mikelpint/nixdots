{
  config,
  lib,
  self,
  user,
  ...
}:
let
  interfaces = {
    pvpn-fr-196 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };

    pvpn-es-88 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };

    pvpn-gr-1 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };

    pvpn-uk-400 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };

    pvpn-us-ny-175 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };

    pvpn-de-200 = {
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
            "10.2.0.0/32"
          ]
          ++ (lib.optionals (config.networking.enableIPv6 or false) [ "::/0" ]);
        }
      ];
    };
  };
in
{
  age = {
    secrets = builtins.listToAttrs (
      builtins.map
        (
          iff:
          let
            name =
              let
                matches = builtins.match "^pvpn-(.*)$" iff;
              in
              if matches != null && (builtins.length matches) > 0 then
                "wg-proton-${builtins.elemAt matches 0}"
              else
                iff;
          in
          {
            inherit name;
            value = {
              owner = user;
              rekeyFile = "${self}/secrets/${name}.age";
            };
          }
        )
        (
          lib.lists.unique (
            (lib.attrsets.attrNames (config.networking.wireguard.interfaces or { }))
            ++ (lib.attrsets.attrNames (config.networking.wg-quick.interfaces or { }))
          )
        )
    );
  };

  networking = {
    wg-quick = {
      inherit interfaces;
    };

    wireguard = {
      interfaces = builtins.mapAttrs (_name: value: {
        inherit (value) privateKeyFile peers;
        ips = value.address;
      }) interfaces;
    };
  };
}
