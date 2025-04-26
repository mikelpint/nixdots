{ pkgs, config, ... }:
let
  transmission = pkgs.transmission_4-gtk;
in
{
  programs = {
    firejail = {
      transmission-cli = {
        executable = "${transmission}/bin/transmission-cli";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-cli.profile";
      };

      transmission-create = {
        executable = "${transmission}/bin/transmission-create";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-create.profile";
      };

      transmission-daemon = {
        executable = "${transmission}/bin/transmission-daemon";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-daemon.profile";
      };

      transmission-edit = {
        executable = "${transmission}/bin/transmission-edit";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-edit.profile";
      };

      transmission-gtk = {
        executable = "${transmission}/bin/transmission-gtk";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-gtk.profile";
      };

      transmission-remote = {
        executable = "${transmission}/bin/transmission-remote";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-remote.profile";
      };

      transmission-show = {
        executable = "${transmission}/bin/transmission-show";
        profile = "${config.programs.firejail.package}/etc/firejail/transmission-show.profile";
      };
    };
  };
}
