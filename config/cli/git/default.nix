{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      extraConfig = {
        init = {
          defaultBranch = "main";
          core = { editor = "helix"; };
          pull = { rebase = false; };
        };
      };
    };
  };
}
