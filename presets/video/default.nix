{ options, config, lib, pkgs, ... }:
with lib;
with lib.custom;
let cfg = config.presets.video;
in {
  options = {
    presets = {
      video = with types; { enable = mkBoolOpt false "Enable video preset"; };
    };
  };

  config = mkIf cfg.enable {
    apps = {
      mpv = enabled;
      peek = enabled;
      obs = enabled;
    };
  };
}
