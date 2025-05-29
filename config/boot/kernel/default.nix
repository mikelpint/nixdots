{ pkgs, lib, ... }:
{
  imports = [
    ./modules
    ./patches
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    crashDump = {
      enable = false;
      reservedMemory = lib.mkDefault "512M-2G:64M,2G-:128M";
      kernelParams = [
        "1"
        "boot.shell_on_fail"
      ];
    };
  };
}
