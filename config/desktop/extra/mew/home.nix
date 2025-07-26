{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ mew ];
  };
}
