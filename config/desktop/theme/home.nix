{ inputs, config, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModule
    ./cursor/home.nix
    ./gtk/home.nix
    ./nix/home.nix
    ./swww/home.nix
  ];

  catppuccin = {
    enable = true;

    flavor = config.catppuccin.pointerCursor.flavor;
    accent = config.catppuccin.pointerCursor.accent;
  };
}
