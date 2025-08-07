{
  pkgs,
  lib,
  config,
  osConfig,
  self,
  inputs,
  ...
}:
{
  imports = [
    ../../presets/desktop/home.nix
    ../../presets/dev/home.nix
    ../../presets/gaming/home.nix
    ../../presets/music/home.nix
    ../../presets/rice/home.nix
    ../../presets/social/home.nix
    ../../presets/video/home.nix

    ../../config/desktop/extra/waybar/presets/desktop/home.nix

    ../../config/hardware/desktop/home.nix
  ];

  systemd = {
    user = {
      services = {
        swww = {
          enable = true;
        };

        wallpaper = {
          Service = {
            ExecStart = ''${
              let
                find = lib.lists.findFirst (
                  let
                    swww = lib.getName pkgs.swww;
                  in
                  x:
                  ((if lib.attrsets.isDerivation x then lib.getName x else null) == swww)
                  && (builtins.pathExists "${lib.getBin x}/bin/swww")
                );
              in
              lib.getBin (
                lib.lists.findFirst find (lib.lists.findFirst find (inputs.swww.packages.${pkgs.system}.swww or pkgs.swww) osConfig.environment.systemPackages) config.home.packages
              )
            }/bin/swww img "${self}/assets/wallpapers/gif/city-night.gif"'';
          };
        };
      };
    };
  };
}
