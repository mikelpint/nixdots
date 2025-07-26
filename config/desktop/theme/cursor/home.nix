{
  lib,
  pkgs,
  config,
  ...
}:
{
  home = {
    pointerCursor = {
      package = lib.mkDefault pkgs.vanilla-dmz;

      x11 = {
        enable = true;
      };

      gtk = {
        enable = true;
      };

      name = "catppuccin-${config.catppuccin.cursors.flavor}-${config.catppuccin.cursors.accent}-cursors";
      size = 24;
    };
  };

  gtk = {
    cursorTheme = {
      inherit (config.home.pointerCursor) name size;
    };
  };

  catppuccin = {
    cursors = {
      enable = true;

      inherit (config.catppuccin) flavor accent;
    };
  };
}
