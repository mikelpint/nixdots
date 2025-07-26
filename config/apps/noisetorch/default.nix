{ pkgs, ... }:
{
  programs = {
    noisetorch = {
      enable = true;
      package = pkgs.noisetorch;
    };
  };
}
