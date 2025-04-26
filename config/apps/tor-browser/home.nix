{ pkgs, ... }:
let
  tor-browser = pkgs.tor-browser-bundle-bin;
in
{
  home = {
    packages = [ tor-browser ];
  };
}
