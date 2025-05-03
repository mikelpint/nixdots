{ pkgs, lib, ... }:
let
  inherit (pkgs) mpv;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        mpv = {
          executable = "${lib.getBin mpv}/bin/mpv";
          profile = "${pkgs.firejail}/etc/firejail/mpv.profile";
        };
      };
    };
  };
}
