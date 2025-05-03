{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        tmux = {
          executable = "${lib.getBin pkgs.tmux}/bin/tmux";
          profile = "${pkgs.firejail}/etc/firejail/tmux.profile";
        };
      };
    };
  };
}
