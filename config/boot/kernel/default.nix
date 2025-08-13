{
  pkgs,
  lib,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/common-config.nix

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

  programs = {
    ccache = {
      packageNames = [ "linux" ];
    };
  };
}
