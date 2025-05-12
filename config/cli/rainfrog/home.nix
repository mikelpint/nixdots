{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ rainfrog ];
  };
}
