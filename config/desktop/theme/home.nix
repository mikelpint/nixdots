{ inputs, config, ... }: {
  imports = [
    inputs.nix-colors.homeManagerModule
    ./cursor/home.nix
    ./gtk/home.nix
    ./nix/home.nix
    ./swww/home.nix
  ];

  catppuccin = {
    enable = true;

    inherit (config.catppuccin.cursors) flavor;
    inherit (config.catppuccin.cursors) accent;
  };
}
