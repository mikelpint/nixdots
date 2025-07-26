{ pkgs, ... }:
{
  programs = {
    ripgrep-all = {
      enable = true;
      package = pkgs.ripgrep-all;
    };
  };
}
