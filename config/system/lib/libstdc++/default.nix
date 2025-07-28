{ pkgs, ... }:
{
  environment = {
    sessionVariables = {
      LD_LIBRARY_PATH = [
        "$NIX_LD_LIBRARY_PATH"
        (pkgs.lib.makeLibraryPath (with pkgs; [ stdenv.cc.cc.lib ]))
      ];
    };
  };

  programs = {
    nix-ld = {
      libraries = with pkgs; [ stdenv.cc.cc ];
    };
  };
}
