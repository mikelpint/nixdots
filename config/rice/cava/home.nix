{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [ cava ];
  };

  catppuccin = {
    cava = {
      inherit (config.catppuccin) enable flavor;
      transparent = true;
    };
  };
}
