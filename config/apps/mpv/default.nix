{ pkgs, ... }:
let
  inherit (pkgs) mpv;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        mpv = {
          executable = "${mpv}/bin/mpv";
          profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
        };
      };
    };
  };
}
