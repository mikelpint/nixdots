{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  programs = {
    fzf = {
      enable = true;

      enableZshIntegration = config.programs.zsh.enable or false;

      tmux = {
        enableShellIntegration = true;
      };
    };

    zsh = lib.mkIf (config.programs.fzf.enable or osConfig.programs.fzf.enable or false) {
      oh-my-zsh = {
        plugins = [ "fzf" ];
      };

      plugins = with pkgs; [
        {
          name = "fzf-tab";
          file = "fzf-tab.plugin.zsh";
          src = fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "fc6f0dcb2d5e41a4a685bfe9af2f2393dc39f689";
            sha256 = "1g3kToboNGXNJTd+LEIB/j76VgPdYqG2PNs3u6Zke9s=";
          };
        }
      ];
    };
  };

  catppuccin = {
    fzf = {
      inherit (osConfig.catppuccin) enable flavor accent;
    };
  };
}
