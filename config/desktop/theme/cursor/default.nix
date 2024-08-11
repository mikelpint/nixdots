{ pkgs, ... }:

let
  flavor = "macchiato";
  accent = "pink";
in
{
  home = {
    pointerCursor = {
      gtk = {
        enable = true;
      };

      x11 = {
        enable = true;
      };

      name = "catppuccin-${flavor}-${accent}-cursors";
      size = 24;
    };
  };

  catppuccin = {
    pointerCursor = {
      enable = true;

      inherit flavor;
      inherit accent;
    };
  };
}
