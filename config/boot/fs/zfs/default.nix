{ config, lib, ... }:
{
  boot = {
    kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
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
