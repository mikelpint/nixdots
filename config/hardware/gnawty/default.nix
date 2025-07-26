# Acer Chromebook 11 (C730-C3F8)
# https://www.chromium.org/chromium-os/developer-library/reference/development/developer-information-for-chrome-os-devices/
# https://chromebook.wiki/chromeosdevices/acergnawty

{ pkgs, lib, ... }:
{
  imports = [
    ../common
  ];

  boot = {
    kernelPackages = lib.mkOverride 75 pkgs.linuxKernel.packages.linux_hardened;
  };
}
