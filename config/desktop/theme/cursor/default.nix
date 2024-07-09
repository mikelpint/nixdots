{ pkgs, ... }: {
  home = {
    pointerCursor = {
      gtk = { enable = true; };
      x11 = { enable = true; };

      name = "Catppuccin-Macchiato-Dark-Cursors";
      size = 24;
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
  };
}
