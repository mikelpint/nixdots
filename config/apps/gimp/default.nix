{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        gimp = {
          executable = "${lib.getBin pkgs.gimp3-with-plugins}/bin/gimp";
          profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
        };
      };
    };
  };
}
