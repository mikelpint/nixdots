{ config, pkgs, ... }:
{
  programs = {
    firejail = {
      gimp = {
        executable = "${pkgs.gimp3-with-plugins}/bin/gimp";
        profile = "${config.programs.firejail.package}/etc/firejail/gimp.profile";
      };
    };
  };
}
