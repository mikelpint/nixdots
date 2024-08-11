{
  pkgs,
  lib,
  spicetify-nix,
  inputs,
  ...
}:

let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
    };
  };

  imports = [ spicetify-nix.homeManagerModule ];

  programs = {
    spicetify = {
      enable = true;

      #spotifyPackage = (import inputs.nur { inherit pkgs; nurpkgs = pkgs; }).repos.nltch.spotify-adblock;
      #spotifyPackage = pkgs.symlinkJoin {
      #  name = "spicetify-wrapped";
      #  paths = [
      #    (pkgs.writeShellScriptBin "spotify" ''exec ${pkgs.spotify}/bin/spotify --enable-wayland-ime'')
      #    pkgs.spotify
      #  ];
      #};

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
