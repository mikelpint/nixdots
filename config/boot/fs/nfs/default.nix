{ lib, config, ... }:
{
  services = {
    nfs = {
      server = {
        enable = lib.mkDefault false;

        lockdPort = 4001;
        mountdPort = 4002;
        statdPort = 4000;

        extraNfsdConfig = '''';
      };
    };
  };

  networking = lib.mkIf config.services.nfs.server.enable {
    firewall = {
      allowedTCPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];

      allowedUDPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];
    };
  };

  boot = {
    supportedFilesystems = {
      nfs = lib.mkDefault true;
    };
  };
}
