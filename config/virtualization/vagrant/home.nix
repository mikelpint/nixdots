{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ vagrant ];
  };
}
