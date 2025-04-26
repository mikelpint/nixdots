{ inputs, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;

      allowBroken = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
          url = "https://github.com/nix-community/NUR/archive/960c1f77cca3e17cd398519496dcd0bb6e495871.tar.gz";
          sha256 = "06vnzp0jkahqrrn61xdprvw3rc94j70m79irrjxsqhvyl62lg48g";
        }) { inherit pkgs; };
      };
    };

    overlays = with inputs; [
      (_final: prev: {
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

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };
}
