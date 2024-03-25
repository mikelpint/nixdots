{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      extraCOnfig = {
        init = {
          defaultBranch = "main";
          core.editor = "helix";
          pull.rebase = false;
        };
      };
    };
  };
}
