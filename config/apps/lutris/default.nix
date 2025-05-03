{ pkgs, lib, ... }:
let
  inherit (pkgs) lutris;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        lutris = {
          executable = "${lib.getBin lutris}/bin/lutris";
          profile = "${pkgs.firejail}/etc/firejail/lutris.profile";
        };
      };
    };
  };
}
