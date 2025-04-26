{pkgs, config, ...}:
let
inherit (pkgs) mpd;
in {
  programs = {
    firejail = {
      mpd = {
        executable = "${mpd}/bin/mpd";
        profile = "${config.programs.firejail.package}/etc/firejail/mpd.profile";
      };
    };
  };
}
