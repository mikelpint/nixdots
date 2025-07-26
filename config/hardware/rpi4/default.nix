{ pkgs, lib, ... }:
{
  imports = [
    <nixos-hardware/raspberry-pi/4>
    ../common
  ];

  hardware = {
    firmware = with pkgs; [ raspberrypifw ];

    raspberry-pi = {
      "4" = {
        apply-overlays-dtmerge = {
          enable = true;
        };
      };
    };

    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  boot = {
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_rpi4;
  };

  environment = {
    systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
  };
}
