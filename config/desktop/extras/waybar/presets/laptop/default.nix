{
  osConfig,
  config,
  lib,
  pkgs,
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
          ;
      };

      style = import ./style.nix { inherit (config) colorscheme; };
    };
  };
}
