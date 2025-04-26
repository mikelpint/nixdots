{ pkgs, ... }:
let
  inherit (pkgs) mpd;
in
{
  home = {
    packages = [ mpd ];
  };
}
