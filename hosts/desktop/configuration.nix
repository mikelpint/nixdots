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

    ../../config/virtualization/libvirtd/vm/win11
  ];
}
