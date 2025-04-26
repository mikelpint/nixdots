{pkgs, config, ...}: {
  programs = {
    firejail = {
      tmux = {
          executable = "${pkgs.tmux}/bin/tmux";
          profile = "${config.programs.firejail.package}/etc/firejail/tmux.profile";
      };
    };
  };
}
