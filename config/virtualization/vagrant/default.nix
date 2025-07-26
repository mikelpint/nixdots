{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../boot/fs/nfs ];

  services = {
    nfs = {
      server = {
        enable = true;
      };
    };
  };

  networking = {
    firewall = {
      interfaces = {
        "virbr1" = lib.mkIf (config.virtualisation.libvirtd.enable or false) {
          allowedTCPPorts = [ 2049 ];
          allowedUDPPorts = [ 2049 ];
        };
      };
    }
    // (lib.mkIf
      (
        !(config.networking.nftables.enable or false)
        && (config.virtualisation.virtualbox.host.enable or false)
      )
      {
        extraCommands = ''
          ${pkgs.iptables}/bin/ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
        '';
      }
    );
  };
}
