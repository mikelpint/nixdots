{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        filezilla = {
          executable = "${pkgs.filezilla}/bin/filezilla";
          profile = "${pkgs.firejail}/etc/firejail/filezilla.profile";
        };
      };
    };
  };
}
