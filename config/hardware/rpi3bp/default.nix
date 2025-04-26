{ pkgs, lib, ... }:
{
  imports = [ ../common ];

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_zen;
  };

  environment = {
    packages = with pkgs; [
      libraspberrypi
      raspberrypifw
    ];
  };
}
