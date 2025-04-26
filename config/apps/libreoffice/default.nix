{ pkgs, ... }:
let
  package = pkgs.libreoffice-fresh;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        libreoffice = {
          executable = "${package}/bin/libreoffice";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-base = {
          executable = "${package}/bin/sbase";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-calc = {
          executable = "${package}/bin/scalc";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-draw = {
          executable = "${package}/bin/sdraw";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-impress = {
          executable = "${package}/bin/simpress";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-math = {
          executable = "${package}/bin/smath";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-office = {
          executable = "${package}/bin/soffice";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-writer = {
          executable = "${package}/bin/swriter";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };
      };
    };
  };
}
