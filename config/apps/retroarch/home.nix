{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ retroarchFull ];
  };
}
