{ pkgs, ... }:
let
  transmission = pkgs.transmission_4-gtk;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        transmission-cli = {
          executable = "${transmission}/bin/transmission-cli";
          profile = "${pkgs.firejail}/etc/firejail/transmission-cli.profile";
        };

        transmission-create = {
          executable = "${transmission}/bin/transmission-create";
          profile = "${pkgs.firejail}/etc/firejail/transmission-create.profile";
        };

        transmission-daemon = {
          executable = "${transmission}/bin/transmission-daemon";
          profile = "${pkgs.firejail}/etc/firejail/transmission-daemon.profile";
        };

        transmission-edit = {
          executable = "${transmission}/bin/transmission-edit";
          profile = "${pkgs.firejail}/etc/firejail/transmission-edit.profile";
        };

        transmission-gtk = {
          executable = "${transmission}/bin/transmission-gtk";
          profile = "${pkgs.firejail}/etc/firejail/transmission-gtk.profile";
        };

        transmission-remote = {
          executable = "${transmission}/bin/transmission-remote";
          profile = "${pkgs.firejail}/etc/firejail/transmission-remote.profile";
        };

        transmission-show = {
          executable = "${transmission}/bin/transmission-show";
          profile = "${pkgs.firejail}/etc/firejail/transmission-show.profile";
        };
      };
    };
  };
}
