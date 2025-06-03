_: {
  programs = {
    direnv = {
      enable = true;
      silent = true;

      nix-direnv = {
        enable = true;
      };

      enableZshIntegration = true;
    };

    git = {
      ignores = [
        ".envrc"
        ".direnv"
      ];
    };
  };

  home = {
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
