{
  imports = [
    ./dconf
    ./git
    ./http
    ./hwutils
    ./lsof
    ./nix-ld
    ./nmap
    ./wine
  ];

  system = {
    stateVersion = "24.05";
  };
}
