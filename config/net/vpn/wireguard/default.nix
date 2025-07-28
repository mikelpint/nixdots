{
  pkgs,
  config,
  lib,
  self,
  user,
  ...
}:
let
  table = "nixos-fw-rpfilter";
in
{
  imports = [
    ../../tun
    ./protonvpn
  ];

  environment = lib.mkIf (config.networking.wireguard.enable or false) {
    systemPackages = with pkgs; [
      wireguard-tools
      wireguard-ui
    ];
  };

  networking =
    let
      inherit
        ((import ./protonvpn {
          inherit self;
          inherit lib;
          inherit config;
          inherit user;
        }).networking
        )
        wireguard
        wg-quick
        ;

      ports = lib.lists.unique (
        (lib.attrsets.mapAttrsToList (_: value: value.listenPort) (wireguard.interfaces or { }))
        ++ (lib.attrsets.mapAttrsToList (_: value: value.listenPort) (wireguard.interfaces or { }))
      );

      generateNatCmds =
        name: ips:
        let
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

          generateCmds =
            action:
            let
              act =
                if action == "add" then
                  "A"
                else if action == "delete" then
                  "D"
                else
                  throw "Only \"add\" and \"delete\" are allowed.";
            in
            lib.strings.concatLines (
              builtins.map (net: ''
                ${pkgs.iptables}/bin/iptables        -${act} FORWARD               -i ${name} -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -${act} POSTROUTING -s ${net} -o eth     -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -t nat -${act} POSTROUTING -s ${net} -o wifi    -j MASQUERADE
              '') nets
            );
        in
        {
          postSetup = generateCmds "add";
          preShutdown = generateCmds "delete";
        };
    in
    {
      wireguard = {
        enable = false;

        interfaces = builtins.mapAttrs (
          name: value:
          let
            inherit (generateNatCmds name value.ips) postSetup preShutdown;
          in
          value
          // {
            postSetup = value.postSetup or postSetup;
            preShutdown = value.postSetup or preShutdown;

            peers = builtins.map (peer: { persistentKeepalive = 25; } // peer) value.peers;
          }
        ) (wireguard.interfaces or { });
      };

      wg-quick = {
        interfaces = builtins.mapAttrs (
          name: value:
          let
            inherit (generateNatCmds name value.address) postSetup preShutdown;
          in
          value
          // {
            postUp = value.postUp or postSetup;
            preDown = value.preDown or preShutdown;
          }
        ) (wg-quick.interfaces or { });
      };
    }
    // (lib.mkIf (config.networking.wireguard.enable or false) {
      networkmanager = {
        unmanaged =
          (builtins.attrNames (config.networking.wireguard.interfaces or { }))
          ++ (builtins.attrNames (config.networking.wg-quick.interfaces or { }));
      };

      firewall = {
        logReversePathDrops = true;
        allowedUDPPorts = ports;
      }
      // (lib.optionalAttrs (!(config.networking.nftables.enable or false)) {
        extraCommands = lib.strings.concatLines (
          builtins.map (port: ''
            iptables  -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
            iptables  -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
            ip6tables -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
            ip6tables -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
          '') ports
        );

        extraStopCommands = lib.strings.concatLines (
          builtins.map (port: ''
            iptables  -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
            iptables  -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
            ip6tables -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
            ip6tables -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
          '') ports
        );
      });

      nftables = lib.mkIf (config.networking.nftables.enable or false) {
        tables = {
          "${table}" = {
            enable = true;

            name = "mangle";
            family = "ip";

            content = ''
              chain input {
                  type filter hook input priority 0; policy accept;
                  ${lib.strings.concatLines (
                    builtins.map (port: ''
                      ip protocol udp udp sport ${builtins.toString port} return
                      ip protocol udp udp dport ${builtins.toString port} return
                    '') ports
                  )}
              }

              chain forward {
                  type filter hook forward priority 0; policy accept;
                  ${lib.strings.concatLines (
                    builtins.map (port: ''
                      ip protocol udp udp sport ${builtins.toString port} return
                      ip protocol udp udp dport ${builtins.toString port} return
                    '') ports
                  )}
              }
            '';
          };
        };
      };
    });
}
