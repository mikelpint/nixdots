{ pkgs, inputs, ... }:
{
  home = {
    packages = [
      (pkgs.writeShellScriptBin "hyprsetup_wallpaper" ''
        systemctl start --user swww
        ${inputs.swww.packages.${pkgs.system}.swww or pkgs.swww}/bin/swww restore
      '')
    ];
  };
}
