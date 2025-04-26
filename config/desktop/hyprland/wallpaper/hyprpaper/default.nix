{ pkgs, ... }:

let
  wallpaper = "/etc/nixos/assets/wallpapers/waves/cat-waves.png";
in
{
  home = {
    packages = with pkgs; [
      hyprpaper

      (writeShellScriptBin "hyprsetup_wallpaper" ''
        hyprpaper &
      '')
    ];
  };

  services = {
    hyprpaper = {
      enable = true;

      settings = {
        ipc = "off";

        splash = false;
        splash_offset = 2.0;

        preload = wallpaper;
        wallpaper = ",${wallpaper}";
      };
    };
  };
}
