{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  home = lib.mkIf (config.services.hyprpaper.enable or false) {
    packages =
      with pkgs;
      with inputs.hyprland.packages."${pkgs.system}";
      [
        hyprpaper

        (writeShellScriptBin "hyprsetup_wallpaper" ''
          pkill hyprpaper
          hyprpaper &
        '')
      ];
  };

  services = {
    hyprpaper = {
      enable = lib.mkDefault true;

      settings = {
        ipc = "off";

        splash = false;
        splash_offset = 2.0;
      };
    };
  };
}
