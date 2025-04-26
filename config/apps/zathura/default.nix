{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        zathura = {
          executable = "${pkgs.zathura}/bin/zathura";
          profile = "${pkgs.firejail}/etc/firejail/gimp.profile";
        };
      };
    };
  };
}
