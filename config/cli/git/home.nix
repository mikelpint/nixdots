{
  programs = {
    git = {
      enable = true;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0x150A5CFDBE9382EE";
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
