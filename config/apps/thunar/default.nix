{ pkgs, ... }:
let
  package = pkgs.xfce.thunar;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        thunar = {
          executable = "${package}/bin/thunar";
          profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
        };
      };
    };
  };
}
