{ pkgs, ... }:

let
  wallpaper = "/etc/nixos/assets/wallpapers/waves/cat-waves.png";
in
{
  home = {
    packages = with pkgs; [
      (writeShellScriptBin "hyprsetup_wallpaper" ''
        hyprctl hyprpaper preload "${wallpaper}"
        hyprctl hyprpaper wallpaper ",${wallpaper}"
      '')
    ];
  };
}
