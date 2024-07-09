{ config, pkgs, inputs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/hardware/laptop

    ../../presets/desktop
    ../../presets/dev
    ../../presets/music
    ../../presets/rice
    ../../presets/social
    ../../presets/video
  ];

  networking = { hostName = "laptopmikel"; };

  systems = {
   laptop = {
     modules = with inputs;
       [
         (import ../../disk/default.nix {
           inherit lib;
           device = "/dev/nvme0n1";
           luks = true;
           swap = true;
         })
       ];
   };
  };
}
