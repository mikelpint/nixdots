{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0xD78A0EF85709BB96!";
        signByDefault = true;
        format = "openpgp";
      };

      extraConfig = {
        hub = { username = "mikelpint"; };

        init = {
          defaultBranch = "main";

          core = { editor = "hx"; };

          pull = { rebase = false; };
        };
      };
    };
  };
}
