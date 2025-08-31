{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ flamelens ];
  };
}
