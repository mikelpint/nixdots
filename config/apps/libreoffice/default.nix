{pkgs, config, ...}:
let
  package = pkgs.libreoffice-fresh;
in {
  programs = {
    firejail = {
      libreoffice = {
        executable = "${package}/bin/libreoffice";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-base = {
        executable = "${package}/bin/sbase";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-calc = {
        executable = "${package}/bin/scalc";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-draw = {
        executable = "${package}/bin/sdraw";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-impress = {
        executable = "${package}/bin/simpress";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-math = {
        executable = "${package}/bin/smath";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-office = {
        executable = "${package}/bin/soffice";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };

      libreoffice-writer = {
        executable = "${package}/bin/swriter";
        profile = "${config.programs.firejail.package}/etc/firejail/libreoffice.profile";
      };
    };
  };
}
