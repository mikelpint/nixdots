{ pkgs, ... }:
{
  home = {
    packages = [
      (pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          RADV_TEX_ANISO = 16;
        };
      })
    ];
  };
}
