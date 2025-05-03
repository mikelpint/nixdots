{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        filezilla = {
          executable = "${lib.getBin pkgs.filezilla}/bin/filezilla";
          profile = "${pkgs.firejail}/etc/firejail/filezilla.profile";
        };
      };
    };
  };
}
