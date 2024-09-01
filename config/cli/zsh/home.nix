{ pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };

      oh-my-zsh = {
        enable = true;

        plugins = [
          "git"
          "vagrant"
          "wd"
          "safe-paste"
          "sprunge"
          "tmux"
          "sudo"
          "vscode"
          "battery"
          "copypath"
        ];

        theme = "ys";
      };
    };
  };
}
