{ pkgs, ... }:
let
  package = pkgs.obs-studio;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        obs-studio = {
          executable = "${package}/bin/obs";
          profile = "${pkgs.firejail}/etc/firejail/obs.profile";
        };
      };
    };
  };
}
