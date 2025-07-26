{ pkgs, osConfig, ... }:
{
  programs = {
    zathura = {
      enable = true;
      package = pkgs.zathura;

      options = {
        font = "JetBrainsMono Nerd Font 10";

        selection-notification = true;
        selection-clipboard = "clipboard";

        scroll-page-aware = true;

        adjust-open = "width";

        statusbar-home-tilde = true;
        statusbar-h-padding = 10;
        statusbar-v-padding = 10;

        recolor = false;
      };
    };
  };

  catppuccin = {
    zathura = {
      enable = true;
      inherit (osConfig.catppuccin) flavor;
    };
  };
}
