{ pkgs, config, ... }:
{
  programs = {
    firejail = {
      imv = {
        executable = "${pkgs.imv}/bin/imv";
        profile = "${config.programs.firejail.package}/etc/firejail/imv.profile";
      };
    };
  };
}
