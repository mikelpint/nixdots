# https://github.com/redyf/nixdots/blob/main/home/system/shell/default.nix

{
  lib,
  pkgs,
  osConfig,
  config,
  user,
  ...
}:
{
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";

      enableCompletion = true;

      autosuggestion = {
        enable = true;

        strategy = [ "history" ];
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
        package = pkgs.oh-my-zsh;

        theme = "ys";

        plugins = [
          "colored-man-pages"
          "colorize"
          "command-not-found"
          "copypath"
          "history-substring-search"
          "safe-paste"
          "wd"
        ]
        ++ (lib.optional (
          (osConfig.security.sudo.enable or false)
          || (builtins.hasAttr "sudo" (config.home.shellAliases or { }))
          || (builtins.hasAttr "sudo" (osConfig.environment.shellAliases or { }))
        ) "sudo")
        ++ (lib.optional (
          (lib.strings.removeSuffix user (osConfig.networking.hostName or "")) == "laptop"
        ) "battery");
      };

      plugins = with pkgs; [
        (
          {
            inherit (zsh-autopair) src;
          }
          // {
            name = "zsh-autopair";
            file = "autopair.zsh";
          }
        )
      ];
    };
  };

  catppuccin = {
    zsh-syntax-highlighting = {
      inherit (config.catppuccin) enable flavor;
    };
  };
}
