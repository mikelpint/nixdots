{ pkgs, config, ... }:
{
  programs = {
    zoxide = {
      enable = true;
      package = pkgs.zoxide;

      enableBashIntegration = true;
      enableZshIntegration = config.programs.zsh.enable or false;

      options = [ "--cmd cd" ];
    };
  };
}
