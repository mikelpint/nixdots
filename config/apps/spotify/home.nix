{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
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

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "macchiato";

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
