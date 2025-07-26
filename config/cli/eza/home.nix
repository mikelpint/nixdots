{ config, pkgs, ... }:
{
  programs = {
    eza = {
      enable = true;
      package = pkgs.eza;

      enableZshIntegration = config.programs.zsh.enable or false;

      icons = "auto";
      git = true;
      colors = "auto";
    };
  };
}
