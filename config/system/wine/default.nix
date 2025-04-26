{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
    wine64Packages.waylandFull
  ];
}
