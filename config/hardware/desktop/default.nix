# My desktop PC
# https://es.pcpartpicker.com/user/mikelpint/saved/xY2M3C

{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_zen;
  };

  imports = [
    ../common

    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./motherboard
    ./net
    ./storage
  ];
}
