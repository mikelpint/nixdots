{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0x14C01046AE976275";
        signByDefault = true;
      };

      extraConfig = {
        hub = {
          username = "mikelpint";
        };

        init = {
          defaultBranch = "main";

          core = {
            editor = "helix";
          };

          pull = {
            rebase = false;
          };
        };
      };
    };
  };
}
