{ pkgs, ... }:
let
  inherit (pkgs) skypeforlinux;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        skypeforlinux = {
          executable = "${skypeforlinux}/bin/skypeforlinux";
          profile = "${pkgs.firejail}/etc/firejail/skypeforlinux.profile";
        };
      };
    };
  };
}
