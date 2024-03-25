{ options, config, lib, pkgs, ... }:
with lib;
with lib.custom;
let cfg = config.presets.gaming;
in {
  options = {
    presets = {
      gaming = with types; {
        enable = mkBoolOpt false "Enable the gaming preset";
      };
    };
  };

  config = mkIf cfg.enable { apps = { steam = enabled; }; };
}
