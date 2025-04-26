{
  pkgs,
  config,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  theme = spicePkgs.themes.catppuccin;
in
{
  programs = {
    firejail = {
      spotify = {
        executable = "${theme}/bin/spotify";
        profile = "${config.programs.firejail.package}/etc/firejail/spotify.profile";
      };
    };
  };
}
