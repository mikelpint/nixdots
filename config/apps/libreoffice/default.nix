{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  programs = {
    firejail = {
      wrappedBinaries =
        let
          binExists = pkg: bin: builtins.pathExists "${lib.getBin pkg}/bin/${bin}";

          find =
            pkg:
            lib.lists.findFirst (
              let
                libreoffice = lib.getName pkg;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == libreoffice)
              && (binExists libreoffice "libreoficce")
            );

          libreoffice =
            lib.lists.findFirst
              (
                pkg:
                find pkg (find null config.environment.systemPackages)
                  config.home-manager.users.${user}.home.packages
              )
              (
                with pkgs;
                [
                  libreoffice-qt6-fresh-unwrapped
                  libreoffice-qt6-fresh

                  libreoffice-qt-fresh-unwrapped
                  libreoffice-qt-fresh

                  libreoffice-fresh-unwrapped
                  libreoffice-fresh

                  libreoffice-qt6-still-unwrapped
                  libreoffice-qt6-still

                  libreoffice-qt-still-unwrapped
                  libreoffice-qt-still

                  libreoffice-still-unwrapped
                  libreoffice-still

                  libreoffice-collabora

                  libreoffice-unwrapped
                  libreoffice

                  libreoffice-bin
                ]
              );
        in
        lib.mkIf (libreoffice != null) {
          libreoffice = lib.mkIf (binExists libreoffice "libreoffice") {
            executable = "${lib.getBin libreoffice}/bin/libreoffice";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-base = lib.mkIf (binExists libreoffice "sbase") {
            executable = "${lib.getBin libreoffice}/bin/sbase";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-calc = lib.mkIf (binExists libreoffice "scalc") {
            executable = "${lib.getBin libreoffice}/bin/scalc";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-draw = lib.mkIf (binExists libreoffice "sdraw") {
            executable = "${lib.getBin libreoffice}/bin/sdraw";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-impress = lib.mkIf (binExists libreoffice "simpress") {
            executable = "${lib.getBin libreoffice}/bin/simpress";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-math = lib.mkIf (binExists libreoffice "smath") {
            executable = "${lib.getBin libreoffice}/bin/smath";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-office = lib.mkIf (binExists libreoffice "soffice") {
            executable = "${lib.getBin libreoffice}/bin/soffice";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };

          libreoffice-writer = lib.mkIf (binExists libreoffice "swriter") {
            executable = "${lib.getBin libreoffice}/bin/swriter";
            profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
          };
        };
    };
  };
}
