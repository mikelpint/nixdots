{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        gedit = {
          executable = "${pkgs.gedit}/bin/gedit";
          profile = "${pkgs.firejail}/etc/firejail/gedit.profile";
        };
      };
    };
  };
}
