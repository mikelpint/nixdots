{ lib, pkgs, ... }:
let
  flavor = "macchiato";
  accent = "pink";
in {
  home = {
    pointerCursor = {
      package = lib.mkDefault pkgs.vanilla-dmz;

      x11 = { enable = true; };
      gtk = { enable = true; };

      name = "catppuccin-${flavor}-${accent}-cursors";
      size = 24;
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
