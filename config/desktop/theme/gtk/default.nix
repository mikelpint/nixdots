{ pkgs, config, ... }:

let
  flavor = config.catppuccin.flavor;
  accent = config.catppuccin.accent;
in {
  home = { packages = with pkgs; [ gsettings-desktop-schemas dconf-editor ]; };

  gtk = {
    enable = true;

    font = { name = "JetBrains Nerd Font"; };

    gtk3 = { extraConfig = { gtk-application-prefer-dark-theme = true; }; };

    catppuccin = {
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
      data = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
        "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      ];
    };
  };
}
