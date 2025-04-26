{pkgs, osConfig, ...}:
let
inherit (pkgs) skypeforlinux;
in {
  programs = {
    firejail = {
      skypeforlinux = {
        executable = "${skypeforlinux}/bin/skypeforlinux";
        profile = "${osConfig.programs.firejail.package}/etc/firejail/skypeforlinux.profile";
      };
    };
  };
}
