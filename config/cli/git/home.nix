{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0xE9392D102A568F9A";
        signByDefault = true;
      };

      extraConfig = {
        hub = {
          username = "mikelpint";
        };

        init = {
          defaultBranch = "main";

          core = {
            editor = "hx";
          };

          pull = {
            rebase = false;
          };
        };
      };
    };
  };
}
