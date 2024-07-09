{ config, pkgs, inputs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../../config
    ../../config/virtualization/vbox/guest

    ../../presets/desktop
    ../../presets/dev
    ../../presets/gaming
    ../../presets/music
    ../../presets/rice
    ../../presets/social
    ../../presets/video
  ];

  networking = { hostName = "nixvm"; };

  systems = {
   vm = {
     modules = with inputs;
       [
         (import ../../disk/default.nix {
           inherit lib;
           device = "/dev/sda";
         })
       ];
   };
  };
}
