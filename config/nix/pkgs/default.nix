{
  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
          url =
            "https://github.com/nix-community/NUR/archive/327169ed2b4766f8112d4fb144bc8f8a7cebf8d.tar.gz";
          sha256 = "03x11544zrlwwh30cfnjly0dd0d7w1ywz68qvz9dzypcdzmndc4z";
        }) { inherit pkgs; };
      };
    };
  };

  home-manager = { useGlobalPkgs = false; };
}

