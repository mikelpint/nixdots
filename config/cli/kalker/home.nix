{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ kalker ];
  };
}
