{ options, config, lib, pkgs, ... }:
with lib;
with lib.custom;
let cfg = config.presets.music;
in {
  options = {
    presets = {
      music = with types; { enable = mkBoolOpt false "Enable music preset"; };
    };
  };

  config = mkIf cfg.enable {
    apps = {
      mpd = enabled;
      spicetify = enabled;
    };
  };
}
