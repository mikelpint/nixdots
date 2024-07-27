{ pkgs, inputs, ... }:

{
  home = {
    packages = [
      pkgs.steam
      (import inputs.nur {
        inherit pkgs;
        nurpkgs = pkgs;
      }).repos.ataraxiasjel.proton-ge
    ];
  };
}
