{pkgs, config, ...}:
let
inherit (pkgs) lutris;
in {
  programs = {
    firejail = {
      lutris = {
        executable = "${lutris}/bin/lutris";
        profile = "${config.programs.firejail.package}/etc/firejail/lutris.profile";
      };
    };
  };
}
