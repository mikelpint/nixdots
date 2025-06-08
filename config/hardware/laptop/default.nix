# ASUS ROG Strix G15 G513IH-HN008

{ pkgs, lib, ... }:
{
  imports = [
    ../common

    ../../boot/secureboot

    ./bluetooth
    ./cpu
    ./display
    ./gpu
    ./input
    ./memory
    ./net
    ./output
    ./power
    ./storage
    ./usb
  ];

  boot = {
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_6_14;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
