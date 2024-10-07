{ lib, pkgs, ... }:
let
  cursorTheme =
    (import ../../theme/cursor/home.nix {
      inherit pkgs;
    }).home.pointerCursor;
  cursor = {
    name = cursorTheme.name;
    size = cursorTheme.size;
  };
in
{
  home = {
    packages = with pkgs; [
      glib
      dconf-editor
      gsettings-desktop-schemas

      (writeShellScriptBin "hyprsetup_cursor" ''
        hyprctl setcursor ${cursor.name} ${builtins.toString cursor.size}
        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme ${cursor.name}
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_cursor" ];

          envd = [
            "GSETTINGS_SCHEMA_DIR,${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas"

            "HYPRCURSOR_THEME,${cursor.name}"
            "HYPRCURSOR_SIZE,${builtins.toString cursor.size}"

            "XCURSOR_THEME,${cursor.name}"
            "XCURSOR_SIZE,${builtins.toString cursor.size}"
          ];

          cursor = {
            enable_hyprcursor = true;

            sync_gsettings_theme = true;

            no_hardware_cursors = lib.mkDefault false;
            no_break_fs_vrr = lib.mkDefault false;
          };
        };
      };
    };
  };
}
