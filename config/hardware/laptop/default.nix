# ASUS ROG Strix G15 G513IH-HN008

{ pkgs, lib, ... }:
{
  imports = [
    ../../boot/secureboot

    ../common

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
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_hardened;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
