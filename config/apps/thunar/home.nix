{ pkgs, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        thunar = super.thunar.override {
          thunarPlugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-vcs-plugin
            thunar-volman
            thunar-media-tags-plugin
          ];
        };
      })
    ];
  };

  home = {
    packages = with pkgs; [ thunar ];
  };
}
