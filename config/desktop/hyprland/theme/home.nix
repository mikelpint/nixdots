{
  pkgs,
  config,
  ...
}:
{
  catppuccin = {
    hyprland = {
      inherit (config.catppuccin) enable flavor accent;
    };
  };

  home = {
    packages = with pkgs; [
      glib
      dconf-editor
      gsettings-desktop-schemas

      (writeShellScriptBin "hyprsetup_theme" ''
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface color-schema 'prefer-${
          if ((config.catppucin.enable or false) && (config.catppuccin.flavor or null) == "latte") then
            "light"
          else
            "dark"
        }'
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_theme" ];

          envd = with pkgs; [
            "GSETTINGS_SCHEMA_DIR,${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}/glib-2.0/schemas"
          ];
        };
      };
    };
  };
}
