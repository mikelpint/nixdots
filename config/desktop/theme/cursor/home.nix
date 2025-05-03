{
  lib,
  pkgs,
  config,
  ...
}:
let
  flavor = "macchiato";
  accent = "pink";
in
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

      name = "catppuccin-${flavor}-${accent}-cursors";
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

      inherit flavor;
      inherit accent;
    };
  };
}
