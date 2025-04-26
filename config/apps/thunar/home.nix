{ pkgs, ... }:
let
  package = pkgs.xfce.thunar;
in {
  programs = {
    thunar = {
      enable = true;
      inherit package;

      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-vcs-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
  };
}
