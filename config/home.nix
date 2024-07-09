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

    stateVersion = "24.05";
  };

  programs = { home-manager = { enable = true; }; };

  nixpkgs = {
    config = {
      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
          url =
            "https://github.com/nix-community/NUR/archive/e833883bd0f137e536ef87c04b7b36dd2d1c9fe7.tar.gz";
          sha256 =
            "5581dcc8bd00b1582ffc75d08568aa35227cd2fe38ccf0dfe6b264c78d47c401";
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

  # imports = [ ./cli ./desktop ./env ./fonts ./tools ./virtualization ];
  imports = [ ./env ./fonts ./tools ./virtualization/home.nix ];
}
