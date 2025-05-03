{ pkgs, lib, ... }:
let
  inherit (pkgs) file-roller nautilus sushi;
in
{
  programs = {
    firejail = {
      wrappedBinaries = {
        file-roller = {
          executable = "${lib.getBin file-roller}/bin/file-roller";
          profile = "${pkgs.firejail}/etc/firejail/file-roller.profile";
        };

        nautilus = {
          executable = "${lib.getBin nautilus}/bin/nautilus";
          profile = "${pkgs.firejail}/etc/firejail/nautilus.profile";
        };

        sushi = {
          executable = "${lib.getBin sushi}/bin/sushi";
          profile = "${pkgs.firejail}/etc/firejail/sushi.profile";
        };
      };
    };
  };
}
