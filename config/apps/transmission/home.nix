{ pkgs, ... }:
let
  transmission = pkgs.transmission_4-gtk;
in {
  home = {
    packages = [ transmission ];
  };
}
