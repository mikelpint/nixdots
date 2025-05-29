{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      mongosh
      mongodb-cli
      mongodb-tools
    ];
  };
}
