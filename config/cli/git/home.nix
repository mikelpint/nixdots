{ pkgs, lib, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;

      userName = "Mikel Pintado";
      userEmail = "mikelpint@protonmail.com";

      signing = {
        key = "0xD78A0EF85709BB96!";
        signByDefault = true;
        format = "openpgp";
      };

      lfs = {
        enable = true;
      };

      delta = {
        enable = true;
        package = pkgs.delta;

        options = {
          decorations = {
            commit-decoration-style = "bold yellow box ul";
            file-decoration-style = "none";
            file-style = "bold yellow ul";
          };

          features = lib.mkDefault "decorations";
          whitespace-error-style = "22 reverse";
        };
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

        core = {
          symlinks = false;
        };

        transfer = {
          fsckobjects = true;
        };

        fetch = {
          fsckobjects = true;
        };

        receive = {
          fsckobjects = true;
        };
      };
    };
  };
}
