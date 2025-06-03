{
  config,
  lib,
  self,
  pkgs,
  user,
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
    secrets = builtins.mapAttrs (name: _value: {
      owner = user;
      rekeyFile = "${self}/secrets/${name}.age";
    }) interfaces;
  };

  networking = {
    enableIPv6 = lib.mkForce true;

    wg-quick = lib.mkIf false {
      interfaces = builtins.mapAttrs (
        name: value:
        value
        // {
          autostart = lib.mkDefault false;
          inherit listenPort;

          postUp =
            lib.lists.foldr
              (a: b: ''
                ${a}
                ${b}
              '')
              ""
              (
                builtins.map (_x: ''
                  ${pkgs.iptables}/bin/iptables -A FORWARD -i ${name} -j ACCEPT
                  ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth -j MASQUERADE
                  ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o wifi -j MASQUERADE
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
                builtins.map (_x: ''
                  ${pkgs.iptables}/bin/iptables -D FORWARD -i ${name} -j ACCEPT
                  ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth -j MASQUERADE
                  ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o wifi -j MASQUERADE
                '') value.address
              );
        }
      ) interfaces;
    };

    wireguard = {
      interfaces = builtins.mapAttrs (
        name: value:
        let
          ips = value.address;
          nets = builtins.map (
            ip:
            let
              matches = builtins.match "^(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])(/3[0-2]|/[12]?[0-9])?$" ip;
              length = builtins.length (
                assert (lib.asserts.assertMsg (matches != null) "Not a valid IP address: \"${ip}\".");
                matches
              );
              addrlen =
                if length == 5 then
                  (lib.strings.toInt (builtins.substring 1 (-1) (builtins.elemAt matches 4)))
                else
                  24;
              power = lib.fix (
                self: x: y:
                if y == 0 then 1 else x * (self x (y - 1))
              );
              mask = lib.lists.foldl (mask: bit: mask + (power (if bit < addrlen then 2 else 0) (31 - bit))) 0 (
                lib.lists.range 0 31
              );
              ipn = lib.lists.foldl (total: sub: total + sub) 0 (
                lib.lists.imap0 (idx: sub: (lib.strings.toInt sub) * (power 2 (8 * idx))) (
                  lib.lists.sublist 0 3 matches
                )
              );
              masked = lib.bitAnd ipn mask;
              getByte32 =
                n: idx:
                (builtins.bitAnd n (
                  lib.lists.foldl (mask: bit: mask + (power 2 (31 - bit))) 0 (
                    lib.lists.range (8 * (3 - idx)) (7 + 8 * (3 - idx))
                  )
                ))
                / (power 2 (8 * idx));
            in
            "${builtins.toString (getByte32 masked 0)}.${builtins.toString (getByte32 masked 1)}.${builtins.toString (getByte32 masked 2)}.${builtins.toString (getByte32 masked 3)}/${builtins.toString addrlen}"
          ) ips;

          nat =
            action:
            lib.strings.concatLines (
              builtins.map (net: ''
                ${pkgs.iptables}/bin/iptables        -${action} FORWARD               -i ${name} -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -${action} POSTROUTING -s ${net} -o eth     -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -t nat -${action} POSTROUTING -s ${net} -o wifi    -j MASQUERADE
              '') nets
            );
        in
        {
          inherit listenPort;
          inherit (value) privateKeyFile;
          inherit ips;
          inherit (value) peers;

          postSetup = nat "A";
          preShutdown = nat "D";
        }
      ) interfaces;
    };
  };
}
