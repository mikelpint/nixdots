{ inputs, osConfig, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModule

    ./cursor/home.nix
    ./gtk/home.nix
    ./nix/home.nix
    ./swww/home.nix
    ./qtct/home.nix
  ];

  catppuccin = {
    inherit (osConfig.catppuccin) enable flavor accent;
  };
}
