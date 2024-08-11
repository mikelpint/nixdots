{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      glib
      dconf-editor
      gsettings-desktop-schemas

      (writeShellScriptBin "hyprsetup_font" ''
        config="$HOME/.config/gtk-3.0/settings.ini"
        if [ ! -f "$config" ]; then exit 1; fi

        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-theme "$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_font" ];

          envd = [
            "GSETTINGS_SCHEMA_DIR,${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"
          ];
        };
      };
    };
  };
}
