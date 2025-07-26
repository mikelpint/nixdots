{ config, ... }:
{
  nix = {
    gc = {
      automatic = !(config.programs.nh.clean.enable or false);
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
