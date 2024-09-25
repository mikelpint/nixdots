{
  networking = {
    firewall = {
      allowedUDPPorts = [ 60001 ];
    };
  };

  programs = {
    mosh = {
      enable = true;
      withUtempter = true;
      openFirewall = true;
    };
  };
}
