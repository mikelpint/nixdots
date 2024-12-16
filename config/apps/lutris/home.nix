{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      lutris
      adwaita-icon-theme
    ];
  };
}
