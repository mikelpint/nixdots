{ inputs, config, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModule
    ./cursor
    ./gtk
    ./nix
    ./swww
  ];

  catppuccin = {
    enable = true;

    flavor = config.catppuccin.pointerCursor.flavor;
    accent = config.catppuccin.pointerCursor.accent;
  };
}
