{ options, config, lib, pkgs, ... }:
with lib;
with lib.custom;
let cfg = config.presets.social;
in {
  options = {
    presets = {
      social = with types; {
        enable = mkBoolOpt false "Enable the social preset";
      };
    };
  };

  config = mkIf cfg.enable { apps = { discord = enabled; }; };
}
