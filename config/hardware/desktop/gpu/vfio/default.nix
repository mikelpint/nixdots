# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/

let
  pci-groups = [
    {
      # AMD Radeon RX 6700 XT
      vendor = "1002";
      graphics = "73df";
      audio = "ab28";
    }

    {
      # NVIDIA GTX 1050
      vendor = "10de";
      graphics = "1c81";
      audio = "0fb9";
    }
  ];

  ids = builtins.map (group: [ "${group.vendor}:${group.graphics}" "${group.vendor}:${group.audio}" ]) pic-groups;
in { pkgs, lib, config, ... }: {
  boot = {
    initrd = { kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ]; };

    kernelParams =
      [ "amd_iommu=on" ("vfio-pci.ids=" + lib.concatStringsSep "," builtins.elemAt ids 1) ];
  };

  virtualisation = { spiceUSBRedirection = { enable = true; }; };
}
