{ pkgs, ... }:
{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "hyprsetup_wallpaper" ''
        systemctl restart --user swww
        systemctl restart --user wallpaper
      '')
    ];
  };
}
