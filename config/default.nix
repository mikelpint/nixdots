{ user, ... }:
{
  users = {
    users = {
      "${user}" = { };
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
    ./location
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
