{ options, config, lib, pkgs, ... }:

with lib;
with lib.custom;
let cfg = config.presets.rice;
in {
  options = {
    presets = {
      rice = with types; { enable = mkBoolOpt false "Enable the rice preset"; };
    };
  };

  config = mkIf cfg.enable {
    rice = {
      btop = enabled;
      cava = enabled;
      fastfetch = enabled;
    };
  };
}
