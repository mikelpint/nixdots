{ pkgs, lib, ... }:
let
  # inherit (pkgs) minecraft;
  prism =
    with pkgs;
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        jdk8
        jdk23

        jetbrains.jdk
      ];
    });
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        # minecraft = {
        #   executable = "${lib.getBin minecraft}/bin/minecraft-launcher";
        #   profile = "${pkgs.firejail}/etc/firejail/minecraft-launcher.profile";
        # };

        prismlauncher = {
          executable = "${lib.getBin prism}/bin/prismlauncher";
          profile = "${pkgs.firejail}/etc/firejail/prismlauncher.profile";
        };
      };
    };
  };
}
