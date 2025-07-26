{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:

{
  home = {
    packages =
      with inputs.hyprland.packages."${pkgs.system}";
      with pkgs;
      [
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

        preload = lib.mkDefault "/etc/nixos/assets/wallpapers/waves/cat-waves.png";
        wallpaper = lib.mkDefault ",${config.services.hyprpaper.preload}";
      };
    };
  };
}
