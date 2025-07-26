{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ miller ];
  };
}
