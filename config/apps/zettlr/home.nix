{ pkgs, ... }:
{
  nixpkgs = {
    config = {
      #allowBroken = true;
    };
  };

  home = {
    packages =
      with pkgs;
      with pkgs.haskellPackages;
      [
        zettlr
        pandoc
        #pandoc-citeproc
      ];
  };
}
