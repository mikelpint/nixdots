{
  home = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv = { enable = true; };
        enableZshIntegration = true;
      };

      environment = { sessionVariables = { DIRENV_LOG_FORMAT = ""; }; };
    };
  };
}
