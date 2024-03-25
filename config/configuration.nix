{ config, lib, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
    ./apps
    ./audio
    ./boot
    ./cli
    ./direnv
    ./env
    ./fonts
    ./graphics
    ./hardware
    ./home
    ./input
    ./langs
    ./locale
    ./net
    ./nix
    ./packages
    ./security
    ./services
    ./time
    ./users
  ];

  system = { stateVersion = "23.11"; };
}

