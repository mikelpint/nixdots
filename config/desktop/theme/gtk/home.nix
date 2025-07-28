{
  pkgs,
  config,
  lib,
  ...
}:
let
  light = (config.catppucin.enable or false) && (config.catppuccin.flavor or null) == "latte";
in
{
  home =
    let
      GTK_THEME = if light then "Adwaita" else "Adwaita-dark";
    in
    {
      sessionVariables = {
        inherit GTK_THEME;
      };

      packages =
        with pkgs;
        [
          gsettings-desktop-schemas
          dconf
          dconf-editor
        ]
        ++ (lib.optional (GTK_THEME == "Adwaita" || GTK_THEME == "Adwaita-dark") pkgs.adwaita-icon-theme);
    };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-${if light then "light" else "dark"}";
      };
    };
  };

  gtk = {
    enable = true;

    font = {
      name = "JetBrains Nerd Font";
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = !light;
      };
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = !light;
      };
    };
  };

  xdg = {
    systemDirs = {
      data = with pkgs; [
        "${gtk3}/share/gsettings-schemas/${gtk3.name}"
        "${gtk4}/share/gsettings-schemas/${gtk4.name}"
        "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      ];
    };
  };
}
