{ pkgs, config, ... }:
let
  package = pkgs.xfce.thunar;
in
{
  programs = {
    firejail = {
      thunar = {
        executable = "${package}/bin/thunar";
        profile = "${config.programs.firejail.package}/etc/firejail/thunar.profile";
      };
    };
  };
}
