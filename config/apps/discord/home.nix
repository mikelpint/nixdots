{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      armcord

      xwaylandvideobridge
    ];
  };
}
