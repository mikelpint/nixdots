{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        gedit = {
          executable = "${lib.getBin pkgs.gedit}/bin/gedit";
          profile = "${pkgs.firejail}/etc/firejail/gedit.profile";
        };
      };
    };
  };
}
