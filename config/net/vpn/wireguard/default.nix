{ pkgs, config, lib, ... }: {
  imports = [ ./protonvpn ];

  environment = { systemPackages = with pkgs; [ wireguard-tools ]; };

  networking = {
    wireguard = { enable = true; };

    firewall = {
      logReversePathDrops = true;
    } // lib.mkIf (!config.networking.nftables.enable) {
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';

      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };

    nftables = lib.mkIf config.networking.nftables.enable {
      tables = {
        nixos-fw-rpfilter = {
          enable = true;

          name = "mangle";
          family = "ip";

          content = ''
            chain input {
                type filter hook input priority 0; policy accept;
                ip protocol udp udp sport 51820 return
                ip protocol udp udp dport 51820 return
            }

            chain forward {
                type filter hook forward priority 0; policy accept;
                ip protocol udp udp sport 51820 return
                ip protocol udp udp dport 51820 return
            }
          '';
        };
      };
    };
  };
}
