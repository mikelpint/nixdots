{ pkgs, ... }:
let
  inherit (pkgs) lutris;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        lutris = {
          executable = "${lutris}/bin/lutris";
          profile = "${pkgs.firejail}/etc/firejail/lutris.profile";
        };
      };
    };
  };
}
