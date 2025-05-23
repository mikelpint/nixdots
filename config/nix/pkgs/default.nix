{ lib, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;

      allowBroken = true;

      permittedInsecurePackages = [
        "python-2.7.18.8"
      ];

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
          url = "https://github.com/nix-community/NUR/archive/960c1f77cca3e17cd398519496dcd0bb6e495871.tar.gz";
          sha256 = lib.fakeSha256;
        }) { inherit pkgs; };
      };
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
  };
}
