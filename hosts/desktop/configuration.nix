{ config, pkgs, lib, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  networking = { hostName = "desktop"; };

  #presets = {
  #  desktop = true;
  #  dev = true;
  #  gaming = true;
  #  music = true;
  #  rice = true;
  #  social = true;
  #  video = true;
  #};

  #systems = {
  #  desktop = {
  #    modules = with inputs;
  #      [
  #        (import ../../disk/default.nix {
  #          inherit lib;
  #          device = "/dev/nvme0n1";
  #        })
  #      ];
  #  };
  #};
}
