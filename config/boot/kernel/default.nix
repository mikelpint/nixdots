{ pkgs, lib, ... }:
{
  imports = [
    ./modules
    ./patches
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    kernelParams = [
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
    ];

    crashDump = {
        enable = true;
        reservedMemory = lib.mkDefault "512M-2G:64M@16M,2G-:128M@16M";
        kernelParams = [
          "1"
          "boot.shell_on_fail"
        ];
    };
  };
}
