{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
    };
  };

  users = lib.mkIf (config.programs.zsh.enable or false) {
    defaultUserShell = pkgs.zsh;
  };
}
