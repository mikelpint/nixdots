{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/hardware/desktop

    ../../presets/desktop
    ../../presets/dev
    ../../presets/gaming
    ../../presets/music
    ../../presets/rice
    ../../presets/social
    ../../presets/video
  ];

  networking = {
    hostName = "desktopmikel";
  };

  systems = {
    desktop = {
      modules = with inputs; [
        (import ../../disk/default.nix {
          inherit lib;
          device = "/dev/nvme0n1";
        })
      ];
    };
  };
}
