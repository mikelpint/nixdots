{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  theme = spicePkgs.themes.catppuccin;
in
{
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
    };
  };

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs = {
    spicetify = {
      enable = true;

      inherit theme;
      colorScheme = config.catppuccin.flavor;

      enabledExtensions = with spicePkgs.extensions; [
        playlistIcons
        lastfm
        historyShortcut
        hidePodcasts
        fullAppDisplay
        shuffle
        seekSong
        adblock
      ];
    };
  };
}
