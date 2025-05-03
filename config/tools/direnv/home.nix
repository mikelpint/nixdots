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
  };

  home = {
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };
  };
}
