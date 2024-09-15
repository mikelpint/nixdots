# My desktop PC
# https://es.pcpartpicker.com/user/mikelpint/saved/xY2M3C

{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_zen;
    # kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
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
    ./storage
  ];
}
