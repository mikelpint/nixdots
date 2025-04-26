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
      "lockdown=confidentiality"
    ];
  };
}
