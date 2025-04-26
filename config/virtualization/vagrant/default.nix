{
  imports = [ ../../boot/fs/nfs ];

  networking = {
    firewall = {
      allowedTCPPorts = [ 2049 ];
      allowedUDPPorts = [ 2049 ];
    };
  };
}
