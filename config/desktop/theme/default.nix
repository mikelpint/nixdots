{ inputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  catppuccin-macchiato =
    (import ./palettes/catppuccin-macchiato.nix).colorscheme;
in {
  imports = [ inputs.nix-colors.homeManagerModule ./gtk ./swww ];

  colorscheme = catppuccin-macchiato;
}
