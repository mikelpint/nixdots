{ pkgs, ... }:
let
  inherit (pkgs) lutris;
in
{
  home = {
    packages = [
      lutris
      pkgs.adwaita-icon-theme
    ];
  };
}
