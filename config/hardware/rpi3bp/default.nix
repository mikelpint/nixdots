{ pkgs, lib, ... }:
{
  imports = [
    <nixos-hardware/raspberry-pi/3>
    ../common

    ./bluetooth
    ./cpu
    ./display
    ./output
  ];

  hardware = {
    firmware = with pkgs; [ raspberrypifw ];
  };

  boot = {
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_rpi3;
  };

  nixpkgs = {
    overlays = [
      (_final: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };

  environment = {
    packages = with pkgs; [
      libraspberrypi
    ];
  };
}
