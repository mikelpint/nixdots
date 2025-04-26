{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (writeShellScriptBin "hyprsetup_wallpaper" ''
        systemctl start --user swww
        ${swww}/bin/swww restore
      '')
    ];
  };
}
