{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ zutty ];
  };
}
