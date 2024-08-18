{ config, lib, ... }:
{
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  };

  services = {
    zfs = {
      autoScrub = {
        enable = true;
      };

      autoSnapshot = {
        enable = true;
      };
    };
  };
}
