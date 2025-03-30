{ pkgs, config, ... }:

let
  inherit (config.catppuccin) flavor;
  inherit (config.catppuccin) accent;
in {
  home = {
    packages = with pkgs; [ gsettings-desktop-schemas dconf-editor ];

    sessionVariables = {
      GTK_THEME = "Adwaita-dark";
      # GTK_THEME = "catppuccin-${flavor}-${accent}";
    };
  };

  gtk = {
    enable = true;

    font = { name = "JetBrains Nerd Font"; };

    gtk3 = { extraConfig = { gtk-application-prefer-dark-theme = true; }; };

    gtk4 = { extraConfig = { gtk-application-prefer-dark-theme = true; }; };
  };

  catppuccin = {
    gtk = {
      inherit flavor;
      inherit accent;

      icon = {
        enable = true;

        inherit flavor;
        inherit accent;
      };

      size = "compact";
      tweaks = [ "rimless" "black" ];
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
