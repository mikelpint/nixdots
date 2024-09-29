# https://github.com/redyf/nixdots/blob/main/home/system/shell/default.nix

{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  themepkg = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zsh-syntax-highlighting";
    rev = "06d519c20798f0ebe275fc3a8101841faaeee8ea";
    sha256 = "sha256-Q7KmwUd9fblprL55W0Sf4g7lRcemnhjh4/v+TacJSfo=";
  };
in
{
  home = {
    sessionVariables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      DIRENV_LOG_FORMAT = "";
    };
  };

  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      enableCompletion = true;

      autosuggestion = {
        enable = true;

        strategy = [
          "history"
        ];
      };

      syntaxHighlighting = {
        enable = true;

        styles = {
          alias = "fg=magenta,bold";
        };

        highlighters = [
          "main"
          "brackets"
          "pattern"
          "cursor"
          "regexp"
          "root"
          #"line"
        ];

        patterns = {
          "rm -rf *" = "fg=white,bold,bg=red";
        };
      };

      oh-my-zsh = {
        enable = true;

        plugins =
          [
            "colored-man-pages"
            "colorize"
            "command-not-found"
            "copypath"
            "git"
            "history-substring-search"
            "safe-paste"
            "sprunge"
            "sudo"
            "tmux"
            "vagrant"
            "vscode"
            "wd"
          ]
          ++ (
            if (lib.strings.removeSuffix "mikel" osConfig.networking.hostName) == "laptop" then
              [ "battery" ]
            else
              [ "" ]
          );

        theme = "ys";
      };

      plugins = with pkgs; [
        {
          name = "forgit";
          file = "forgit.plugin.zsh";
          src = fetchFromGitHub {
            owner = "wfxr";
            repo = "forgit";
            rev = "99cda3248c205ba3c4638c4e461afce01a2f8acb";
            sha256 = "0jd0nl0nf7a5l5p36xnvcsj7bqgk0al2h7rdzr0m1ldbd47mxdfa";
          };
        }

        {
          name = "zsh-autopair";
          file = "zsh-autopair.plugin.zsh";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
            sha256 = "0q9wg8jlhlz2xn08rdml6fljglqd1a2gbdp063c8b8ay24zz2w9x";
          };
        }

        {
          name = "fzf-tab";
          file = "fzf-tab.plugin.zsh";
          src = fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "5a81e13792a1eed4a03d2083771ee6e5b616b9ab";
            sha256 = "0lfl4r44ci0wflfzlzzxncrb3frnwzghll8p365ypfl0n04bkxvl";
          };
        }

        {
          name = "ctp-zsh-syntax-highlighting";
          src = themepkg;
          file = themepkg + "/themes/catppuccin_${osConfig.catppuccin.flavor}-zsh-syntax-highlighting.zsh";
        }
      ];
    };
  };
}
