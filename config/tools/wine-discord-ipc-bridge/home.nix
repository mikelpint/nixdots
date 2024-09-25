{ pkgs, inputs, ... }:
{
  home = {
    packages = with pkgs; [ inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge ];
  };
}