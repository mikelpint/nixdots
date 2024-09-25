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

  age = {
    identityPaths = [ "/home/mikel/.ssh/id_rsa" ];

    rekey = {
      hostPubkey = builtins.readFile ./host.pub;
      masterIdentities = [ "/home/mikel/.ssh/id_rsa" ];
    };
  };
}
