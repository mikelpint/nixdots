{ lib, pkgs, ... }:
let
  flavor = "macchiato";
  accent = "pink";
in
{
  home = {
    pointerCursor = {
      package = lib.mkDefault pkgs.vanilla-dmz;

      gtk = {
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
