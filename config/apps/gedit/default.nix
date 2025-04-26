{ pkgs, config, ... }:
{
  programs = {
    firejail = {
      gedit = {
        executable = "${pkgs.gedit}/bin/gedit";
        profile = "${config.programs.firejail.package}/etc/firejail/gedit.profile";
      };
    };
  };
}
