{ pkgs, config, ... }:
{
  programs = {
    firejail = {
      filezilla = {
        executable = "${pkgs.filezilla}/bin/filezilla";
        profile = "${config.programs.firejail.package}/etc/firejail/filezilla.profile";
      };
    };
  };
}
