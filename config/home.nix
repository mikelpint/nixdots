{ inputs, pkgs, lib, ... }:
let
  nixpkgs = import inputs.nixpkgs {
    fastfetch = pkgs.fastfetch;
    mongodb-compass = pkgs.mongodb-compass;

    config = { allowUnfree = true; };
  };
in {
  home = lib.mkForce {
    username = "mikel";
    homeDirectory = "/home/mikel";

    sessionPath = [ "$HOME/.local/bin" ];

    stateVersion = "23.11";
  };

  programs = { home-manager = { enable = true; }; };

  nixpkgs = {
    config = {
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
          url =
            "https://github.com/nix-community/NUR/archive/327169ed2b4766f8112d4fb144bc8f8a7cebf8bd.tar.gz";
          sha256 = "03x11544zrlwwh30cfnjly0dd0d7w1ywz68qvz9dzypcdzmndc4z";
        }) { inherit pkgs; };
      };
    };

    overlays = with inputs;
      [
        (final: prev: {
          sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
            pname = "sf-mono-liga-bin";
            version = "dev";
            src = sf-mono-liga-src;
            dontConfigure = true;
            installPhase = ''
              mkdir -p $out/share/fonts/opentype
              cp -R $src/*.otf $out/share/fonts/opentype/
            '';
          };
        })
      ];
  };

  imports = [
    ./apps
    ./cli
    ./desktop
    ./env
    ./fonts
    ./langs
    ./rice
    ./tools
    ./virtualization
  ];

  fonts = { fontconfig = { enable = true; }; };
}
