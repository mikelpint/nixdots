{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  home = lib.mkForce {
    username = "mikel";
    homeDirectory = "/home/mikel";

    sessionPath = [ "$HOME/.local/bin" ];

    stateVersion = "24.05";
  };

  programs = {
    home-manager = {
      enable = true;
    };

    nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./cli/home.nix
    ./env/home.nix
    ./fonts/home.nix
    ./graphics/home.nix
    ./net/home.nix
    ./security/home.nix
    ./services/home.nix
    ./tools/home.nix
    ./virtualization/home.nix
  ];
}
