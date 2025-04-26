{pkgs, config, ...}:
let
  package = pkgs.obs-studio;
in {
  programs = {
    firejail = {
      obs-studio = {
        executable = "${package}/bin/obs";
        profile = "${config.programs.firejail.package}/etc/firejail/obs.profile";
      };
    };
  };
}
