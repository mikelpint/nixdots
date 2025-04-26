{pkgs, config, ...}:
let
inherit (pkgs) file-roller nautilus sushi;
in {
  programs = {
    firejail = {
      file-roller = {
        executable = "${file-roller}/bin/file-roller";
        profile = "${config.programs.firejail.package}/etc/firejail/file-roller.profile";
      };

      nautilus = {
        executable = "${nautilus}/bin/nautilus";
        profile = "${config.programs.firejail.package}/etc/firejail/nautilus.profile";
      };

      sushi = {
        executable = "${sushi}/bin/sushi";
        profile = "${config.programs.firejail.package}/etc/firejail/sushi.profile";
      };
    };
  };
}
