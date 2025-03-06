{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      legcord

      kdePackages.xwaylandvideobridge
    ];
  };
}
