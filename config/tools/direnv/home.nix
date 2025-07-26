{ lib, config, ... }:
{
  programs = {
    direnv = {
      enable = true;
      silent = true;

      nix-direnv = {
        enable = true;
      };

      enableZshIntegration = config.programs.zsh.enable or false;

      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    git = {
      ignores = [
        ".envrc"
        ".direnv"
      ];
    };

    zed-editor = {
      userSettings = lib.mkIf (config.programs.direnv.enable or false) {
        load_direnv = "shell_hook";
      };
    };
  };

  home = {
    sessionVariables = lib.mkIf (config.programs.direnv.enable or false) {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
