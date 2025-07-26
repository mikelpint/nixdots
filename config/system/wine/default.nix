{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      wineWowPackages.waylandFull
      wine64Packages.waylandFull

      winetricks
    ];
  };
}
