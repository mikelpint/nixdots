{
  imports = [
    ./dconf
    ./flatpak
    ./git
    ./http
    ./hwutils
    ./lib
    ./lsof
    ./nix-ld
    ./nmap
    ./wine
  ];

  system = {
    stateVersion = "24.05";
  };
}
