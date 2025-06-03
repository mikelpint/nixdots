{
  pkgs,
  config,
  lib,
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

  environment = {
    systemPackages = with pkgs; [ wireguard-tools ];
  };

  networking =
    {
      wireguard = {
        enable = true;
      };
    }
    // lib.mkIf config.networking.wireguard.enable (
      let
        interfaces =
          (config.networking.wireguard.interfaces or { }) // (config.networking.wg-quick.interfaces or { });
        ports = lib.attrsets.mapAttrsToList (_: value: value.listenPort) interfaces;
      in
      {
        firewall =
          {
            logReversePathDrops = true;
            allowedUDPPorts = ports;
          }
          // lib.mkIf (!config.networking.nftables.enable) {
            extraCommands = lib.strings.concatLines (
              builtins.map (port: ''
                iptables -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
                iptables -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
                ip6tables -t mangle -I ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN
                ip6tables -t mangle -I ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN
              '') ports
            );

            extraStopCommands = lib.strings.concatLines (
              builtins.map (port: ''
                iptables -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
                iptables -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
                ip6tables -t mangle -D ${table} -p udp -m udp --sport ${builtins.toString port} -j RETURN || true
                ip6tables -t mangle -D ${table} -p udp -m udp --dport ${builtins.toString port} -j RETURN || true
              '') ports
            );
          };

        nftables = lib.mkIf config.networking.nftables.enable {
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
      }
    );
}
