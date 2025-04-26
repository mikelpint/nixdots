{pkgs, config, ...}:
let
inherit (pkgs) mpv;
in {
  programs = {
    firejail = {
      mpv = {
        executable = "${mpv}/bin/mpv";
        profile = "${config.programs.firejail.package}/etc/firejail/mpv.profile";
      };
    };
  };
}
