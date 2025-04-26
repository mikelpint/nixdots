{ pkgs, ... }:
let
inherit (pkgs) skypeforlinux;
in {
  home = {
    packages = [ skypeforlinux ];
  };
}
