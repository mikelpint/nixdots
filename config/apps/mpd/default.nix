{ pkgs, lib, ... }:
let
  inherit (pkgs) mpd;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        mpd = {
          executable = "${lib.getBin mpd}/bin/mpd";
          profile = "${pkgs.firejail}/etc/firejail/mpd.profile";
        };
      };
    };
  };
}
