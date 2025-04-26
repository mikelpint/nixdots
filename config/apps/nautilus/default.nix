{ pkgs, ... }:
let
  inherit (pkgs) file-roller nautilus sushi;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        file-roller = {
          executable = "${file-roller}/bin/file-roller";
          profile = "${pkgs.firejail}/etc/firejail/file-roller.profile";
        };

        nautilus = {
          executable = "${nautilus}/bin/nautilus";
          profile = "${pkgs.firejail}/etc/firejail/nautilus.profile";
        };

        sushi = {
          executable = "${sushi}/bin/sushi";
          profile = "${pkgs.firejail}/etc/firejail/sushi.profile";
        };
      };
    };
  };
}
