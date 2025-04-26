{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        gimp = {
          executable = "${pkgs.gimp3-with-plugins}/bin/gimp";
          profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
        };
      };
    };
  };
}
