{ pkgs, osConfig, ... }:
let
    inherit (pkgs) mpd;
in{
  home = {
    packages = [ mpd ];
  };

  programs = {
    firejail = {
      mpd = {
        executable = "${mpd}/bin/gimp";
        profile = "${osConfig.programs.firejail.package}/etc/firejail/mpd.profile";
      };
    };
  };
}
