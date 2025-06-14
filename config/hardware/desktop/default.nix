# My desktop PC
# https://es.pcpartpicker.com/user/mikelpint/saved/xY2M3C

{ pkgs, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_zen;
  };

  imports = [
    ../common
    ../common/output/printer/hp

    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./motherboard
    ./net
    ./output
    ./power
    ./storage
    ./usb
  ];
}
