{ pkgs, lib, ... }:
let
  package = pkgs.libreoffice-fresh;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        libreoffice = {
          executable = "${lib.getBin package}/bin/libreoffice";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-base = {
          executable = "${lib.getBin package}/bin/sbase";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-calc = {
          executable = "${lib.getBin package}/bin/scalc";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-draw = {
          executable = "${lib.getBin package}/bin/sdraw";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-impress = {
          executable = "${lib.getBin package}/bin/simpress";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-math = {
          executable = "${lib.getBin package}/bin/smath";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-office = {
          executable = "${lib.getBin package}/bin/soffice";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };

        libreoffice-writer = {
          executable = "${lib.getBin package}/bin/swriter";
          profile = "${pkgs.firejail}/etc/firejail/libreoffice.profile";
        };
      };
    };
  };
}
