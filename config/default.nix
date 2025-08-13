{ user, config, ... }:
{
  users = {
    users = {
      "${user}" = { };
    };
  };

  home-manager = {
    users = {
      root = {
        home = {
          inherit (config.system) stateVersion;
        };
      };
    };
  };

  imports = [
    ./apps
    ./audio
    ./boot
    ./console
    ./cli
    ./env
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
