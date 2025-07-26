{ config, ... }:
{
  catppuccin = {
    yazi = {
      inherit (config.catppuccin) enable flavor accent;
    };
  };
}
