{ pkgs, ... }:
let
  package = pkgs.chromium;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        chromium = {
          executable = "${package}/bin/chromium";
          profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
        };
      };
    };
  };
}
