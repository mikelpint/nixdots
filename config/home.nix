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
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  imports = [
    ./cli/home.nix
    ./env
    ./fonts
    ./tools
    ./virtualization/home.nix
  ];
}
