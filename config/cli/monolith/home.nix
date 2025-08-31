{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ monolith ];
  };
}
