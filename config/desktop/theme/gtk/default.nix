{ pkgs, config, ... }:

let
  cursor =
    ((import ../cursor/default.nix) { inherit pkgs; }).home.pointerCursor;
in {
  gtk = {
    enable = true;

    cursorTheme = {
      name = cursor.name;
      size = cursor.size;
      package = cursor.package;
    };

    theme = {
      name = "Catppuccin-Macchiato-Compact-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-folders;
    };
  };

  xdg = {
    configFile = {
      "gtk-4.0/assets".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source =
        "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
