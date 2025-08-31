{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ sttr ];
  };
}
