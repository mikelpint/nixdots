{
  pkgs,
  lib,
  user,
  ...
}:
let
  transmission = pkgs.transmission_4-gtk;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        transmission-cli = {
          executable = "${lib.getBin transmission}/bin/transmission-cli";
          profile = "${pkgs.firejail}/etc/firejail/transmission-cli.profile";
        };

        transmission-create = {
          executable = "${lib.getBin transmission}/bin/transmission-create";
          profile = "${pkgs.firejail}/etc/firejail/transmission-create.profile";
        };

        transmission-daemon = {
          executable = "${lib.getBin transmission}/bin/transmission-daemon";
          profile = "${pkgs.firejail}/etc/firejail/transmission-daemon.profile";
        };

        transmission-edit = {
          executable = "${lib.getBin transmission}/bin/transmission-edit";
          profile = "${pkgs.firejail}/etc/firejail/transmission-edit.profile";
        };

        transmission-gtk = {
          executable = "${lib.getBin transmission}/bin/transmission-gtk";
          profile = "${pkgs.firejail}/etc/firejail/transmission-gtk.profile";
        };

        transmission-remote = {
          executable = "${lib.getBin transmission}/bin/transmission-remote";
          profile = "${pkgs.firejail}/etc/firejail/transmission-remote.profile";
        };

        transmission-show = {
          executable = "${lib.getBin transmission}/bin/transmission-show";
          profile = "${pkgs.firejail}/etc/firejail/transmission-show.profile";
        };
      };
    };
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [ "transmission" ];
      };
    };
  };
}
