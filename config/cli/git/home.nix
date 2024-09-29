{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0x18AE4D99146E63FA";
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
