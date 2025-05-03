{ pkgs, lib, ... }:
let
  package = pkgs.chromium;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        chromium = {
          executable = "${lib.getBin package}/bin/chromium";
          profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
        };
      };
    };
  };
}
