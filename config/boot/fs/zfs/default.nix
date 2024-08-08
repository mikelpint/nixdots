{ config, ... }: {
  boot = {
    kernelPackages =
      [ config.boot.zfs.package.package.latestCompatibleLinuxPackages ];
  };
}
