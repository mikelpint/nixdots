{ pkgs, ... }:
let
  inherit (pkgs) mpd;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        mpd = {
          executable = "${mpd}/bin/mpd";
          profile = "${pkgs.firejail}/etc/firejail/mpd.profile";
        };
      };
    };
  };
}
