{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ amule ];
  };
}
