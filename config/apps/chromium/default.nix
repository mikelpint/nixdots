{ pkgs, config, ... }:
let
  package = pkgs.chromium;
in
{
  programs = {
    firejail = {
      transmission-cli = {
        executable = "${package}/bin/chromium";
        profile = "${config.programs.firejail.package}/etc/firejail/chromium.profile";
      };
    };
  };
}
