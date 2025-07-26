{
  osConfig,
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  programs = {
    waybar = {
      settings = import ./config.nix {
        inherit
          osConfig
          config
          lib
          pkgs
          user
          ;
      };

      style = import ./style.nix { inherit (config) colorscheme; };
    };
  };
}
