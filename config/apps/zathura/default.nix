{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        zathura = {
          executable = "${lib.getBin pkgs.zathura}/bin/zathura";
          profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
        };
      };
    };
  };
}
