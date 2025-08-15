{
  pkgs,
  config,
  lib,
  self,
  user,
  ...
}:
let
  protonvpn = import ./protonvpn {
    inherit
      config
      lib
      self
      user
      ;
  };

  inherit (protonvpn.networking or { }) wireguard wg-quick;

  table = "nixos-fw-rpfilter";

  ports = lib.lists.unique (
    (lib.attrsets.mapAttrsToList (_: value: value.listenPort) (
      config.networking.wireguard.interfaces or { }
    ))
    ++ (lib.attrsets.mapAttrsToList (_: value: value.listenPort) (
      config.networking.wg-quick.interfaces or { }
    ))
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
        ''
          ${pkgs.iptables}/bin/iptables        -${act} FORWARD               -i ${name} -j ACCEPT
          ${lib.strings.concatLines (
            builtins.map (
              net:
              let
                op = if action == "add" then "||" else "&&";
              in
              ''
                ${pkgs.iptables}/bin/iptables -t nat -C      POSTROUTING -s ${net} -o eth     -j MASQUERADE ${op} \
                ${pkgs.iptables}/bin/iptables -t nat -${act} POSTROUTING -s ${net} -o eth     -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -t nat -C      POSTROUTING -s ${net} -o wifi    -j MASQUERADE ${op} \
                ${pkgs.iptables}/bin/iptables -t nat -${act} POSTROUTING -s ${net} -o wifi    -j MASQUERADE
              ''
            ) nets
          )}
        '';
    in
    {
      postSetup = generateCmds "add";
      preShutdown = generateCmds "delete";
    };
in
{
  imports = [
    ../../tun
    ./protonvpn
  ];

  environment =
    lib.mkIf (config.networking.wireguard.enable or config.networking.wg-quick.enable or false)
      {
        systemPackages = with pkgs; [
          wireguard-tools
          wireguard-ui
          wg-friendly-peer-names
        ];
      };

  networking = {
    wireguard = {
      enable = false;

      interfaces = builtins.mapAttrs (
        name: value:
        (builtins.mapAttrs (_name: value: lib.mkDefault value) value)
        // (
          let
            inherit (generateNatCmds name (value.ips or [ ])) postSetup preShutdown;
          in
          {
            postSetup = if (lib.strings.trim (value.postSetup or "")) == "" then postSetup else value.postSetup;
            preShutdown =
              if (lib.strings.trim (value.preShutdown or "")) == "" then preShutdown else value.preShutdown;
            listenPort = if (value.listenPort or null) == null then 51820 else value.listenPort;
            mtu = if (value.mtu or null) == null then 1360 else value.mtu;
            peers = builtins.map (
              peer:
              (builtins.mapAttrs (_name: value: lib.mkDefault value) peer)
              // {
                persistentKeepalive =
                  if (peer.persistentKeepalive or null) == null then 25 else peer.persistentKeepalive;
              }
            ) (value.peers or [ ]);
          }
        )
      ) (wireguard.interfaces or { });
    };

    wg-quick = {
      interfaces = builtins.mapAttrs (
        name: value:
        (builtins.mapAttrs (_name: value: lib.mkDefault value) value)
        // (
          let
            inherit (generateNatCmds name (value.ips or [ ])) postSetup preShutdown;
          in
          {
            postUp = if (lib.strings.trim (value.postUp or "")) == "" then postSetup else value.postUp;
            preDown = if (lib.strings.trim (value.preDown or "")) == "" then preShutdown else value.preDown;
            listenPort = if (value.listenPort or null) == null then 51820 else value.listenPort;
            autostart = if (value.autostart or null) == null then false else value.autostart;
          }
        )
      ) (wg-quick.interfaces or { });
    };

    networkmanager = {
      unmanaged = [
        "type:wireguard"
      ]
      ++ (builtins.map (name: "interface-name:${name}") (
        (builtins.attrNames (config.networking.wireguard.interfaces or { }))
        ++ (builtins.attrNames (config.networking.wg-quick.interfaces or { }))
      ));
    };

    firewall =
      lib.mkIf (config.networking.wireguard.enable or config.networking.wg-quick.enable or false)
        {
          checkReversePath = false;
          logReversePathDrops = true;
          allowedUDPPorts = ports;

          extraCommands = lib.optionalString (!(config.networking.nftables.enable or false)) (
            lib.strings.concatLines (
              builtins.map (port: ''
                ${pkgs.iptables}/bin/iptables  -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
                ${pkgs.iptables}/bin/iptables  -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
                ${pkgs.iptables}/bin/ip6tables -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
                ${pkgs.iptables}/bin/ip6tables -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
              '') ports
            )
          );

          extraStopCommands = lib.optionalString (!(config.networking.nftables.enable or false)) (
            lib.strings.concatLines (
              builtins.map (port: ''
                ${pkgs.iptables}/bin/iptables  -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
                ${pkgs.iptables}/bin/iptables  -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
                ${pkgs.iptables}/bin/ip6tables -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
                ${pkgs.iptables}/bin/ip6tables -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
              '') ports
            )
          );
        };

    nftables =
      lib.mkIf (config.networking.wireguard.enable or config.networking.wg-quick.enable or false)
        {
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
  };

  boot = lib.mkIf (config.networking.wireguard.enable or config.networking.wg-quick.enable or false) {
    kernelModules = [ "wireguard" ];
  };
}
