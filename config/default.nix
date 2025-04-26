_: {
  users = {
    users = {
      mikel = { };
    };
  };

  imports = [
    ./audio
    ./boot
    ./console
    ./cli
    ./fonts
    ./graphics
    ./input
    ./locale
    ./net
    ./nix
    ./security
    ./services
    ./time
    ./tools
    ./system
    ./users
    ./virtualization
  ];
}
