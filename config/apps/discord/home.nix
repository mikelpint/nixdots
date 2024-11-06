{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      legcord

      xwaylandvideobridge
    ];
  };
}
