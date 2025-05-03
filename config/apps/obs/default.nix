{ pkgs, lib, ... }:
let
  package = pkgs.obs-studio;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        obs-studio = {
          executable = "${lib.getBin package}/bin/obs";
          profile = "${pkgs.firejail}/etc/firejail/obs.profile";
        };
      };
    };
  };
}
