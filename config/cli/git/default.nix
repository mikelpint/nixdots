{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      extraConfig = {
        hub = { username = "mikelpint"; };

        init = {
          defaultBranch = "main";
          core = { editor = "helix"; };
          pull = { rebase = false; };
        };
      };
    };
  };
}
