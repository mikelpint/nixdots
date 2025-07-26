{
  pkgs,
  lib,
  user,
  config,
  ...
}:
{
  config =
    let
      transmission =
        if (config.services.transmission.enable or false) then
          config.services.transmission.package or pkgs.transmission_4
        else
          (
            let
              find = lib.lists.findFirst (
                let
                  transmission_4 = lib.getName pkgs.transmission_4;
                  transmission_4-gtk = lib.getName pkgs.transmission_4-gtk;
                  transmission_4-qt6 = lib.getName pkgs.transmission_4-qt6;
                  transmission_4-qt5 = lib.getName pkgs.transmission_4-qt5;
                  transmission_4-qt = lib.getName pkgs.transmission_4-qt;
                  transmission_3 = lib.getName pkgs.transmission_3;
                  transmission_3_noSystemd = lib.getName pkgs.transmission_3_noSystemd;
                  transmission_3-gtk = lib.getName pkgs.transmission_3-gtk;
                  transmission_3-qt = lib.getName pkgs.transmission_3-qt;
                  transmission = lib.getName pkgs.transmission;
                  transmission-gtk = lib.getName pkgs.transmission-gtk;
                  transmission-qt = lib.getName pkgs.transmission-qt;
                in
                x:
                let
                  name = if lib.attrsets.isDerivation x then lib.getName x else null;
                in
                name == transmission_4
                || name == transmission_4-gtk
                || name == transmission_4-qt6
                || name == transmission_4-qt5
                || name == transmission_4-qt
                || name == transmission_3
                || name == transmission_3_noSystemd
                || name == transmission_3-gtk
                || name == transmission_3-qt
                || name == transmission
                || name == transmission-gtk
                || name == transmission-qt
              );
            in
            find (find null config.environment.systemPackages) config.home-manager.users.${user}.home.packages
          );
    in
    lib.mkIf (transmission != null) {
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

      # users = {
      #   users = {
      #     "${user}" = {
      #       extraGroups = [ "transmission" ];
      #     };
      #   };
      # };
    };
}
