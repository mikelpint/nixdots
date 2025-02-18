# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/

let
  pci-groups = [
    {
      # AMD Radeon RX 6700 XT
      vendor = "1002";

      graphics = "73df";
      audio = "ab28";
      upstream = "1478";
      downstream = "1479";
    }

    {
      # AMD Radeon R9 FURY
      vendor = "1002";

      graphics = "7300";
      audio = "aae8";
    }

    # {
    #   # NVIDIA GTX 1050
    #   vendor = "10de";

    #   graphics = "1c81";
    #   audio = "0fb9";
    # }
  ];

  ids = builtins.map (group:
    builtins.map (attr: "${group.vendor}:${group.${attr}}")
    (builtins.filter (attr: attr != "vendor") (builtins.attrNames group)))
    pci-groups;
in { lib, config, ... }: {
  boot = {
    initrd = { kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ]; };

    kernelParams = lib.mkIf false [
      "amd_iommu=on"
      "iommu=pt"
      ("vfio-pci.ids=" + lib.concatStringsSep "," (builtins.elemAt ids
        (if (builtins.elem "amdgpu" config.services.xserver.videoDrivers) then
        #1
          0
        else
          0)))
    ];
  };

  virtualisation = { spiceUSBRedirection = { enable = true; }; };
}
