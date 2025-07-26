{ pkgs, config, ... }:
{
  programs = {
    micro = {
      enable = true;
      package = pkgs.micro;
    };
  };

  catppuccin = {
    micro = {
      inherit (config.catppuccin) enable flavor;
      transparent = false;
    };
  };
}
