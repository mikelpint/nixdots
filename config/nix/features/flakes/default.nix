{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      accept-flake-config = true;

      experimental-features = [
        "flakes"
      ];
    };
  };
}
