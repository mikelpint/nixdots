# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/

let
  # AMD Radeon RX 6700 XT
  vendor = "1002";
  graphics = "73df";
  audio = "ab28";

  ids = [
    "${vendor}:${graphics}"
    "${vendor}:${audio}"
  ];
in
{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    initrd = {
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
    };

    kernelParams = [
      "amd_iommu=on"
      ("vfio-pci.ids=" + lib.concatStringsSep "," ids)
    ];
  };

  virtualisation = {
    spiceUSBRedirection = {
      enable = true;
    };
  };
}
