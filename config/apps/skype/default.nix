{ pkgs, lib, ... }:
let
  inherit (pkgs) skypeforlinux;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        skypeforlinux = {
          executable = "${lib.getBin skypeforlinux}/bin/skypeforlinux";
          profile = "${pkgs.firejail}/etc/firejail/skypeforlinux.profile";
        };
      };
    };
  };
}
