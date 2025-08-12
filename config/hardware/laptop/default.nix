# ASUS ROG Strix G15 G513IH-HN008

{ pkgs, lib, ... }:
{
  imports = [
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
    # kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_hardened;
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_6_16;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
