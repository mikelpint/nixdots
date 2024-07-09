{ inputs, ... }: {
  imports = [ inputs.nix-colors.homeManagerModule ./cursor ./gtk ./nix ./swww ];
}
