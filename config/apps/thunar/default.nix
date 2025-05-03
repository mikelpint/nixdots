{ pkgs, lib, ... }:
let
  package = pkgs.xfce.thunar;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        thunar = {
          executable = "${lib.getBin package}/bin/thunar";
          profile = "${pkgs.firejail}/etc/firejail/thunar.profile";
        };
      };
    };
  };
}
