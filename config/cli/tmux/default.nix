{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        tmux = {
          executable = "${pkgs.tmux}/bin/tmux";
          profile = "${pkgs.firejail}/etc/firejail/tmux.profile";
        };
      };
    };
  };
}
