# https://gist.github.com/akitaonrails/d4d98b03f1126c81a20eb3ea57027ad2
# https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
# https://github.com/ifd3f/infra/blob/main/machines/chungus/win10.xml

_: {
  virtualisation = {
    libvirtd = {
      hooks = {
        qemu = {
          # "win11/prepare/begin/bind_vfio.sh" = bind_vfio;
          # "win11/prepare/release/unbind_vfio.sh" = unbind_vfio;

          # "win11/prepare/begin/cpu_mode_performance.sh" = cpu_mode_performance;
          # "win11/prepare/release/cpu_mode_ondemand.sh" = cpu_mode_ondemand;

          # "win11/prepare/begin/alloc_hugepages.sh" = alloc_hugepages;
          # "win11/prepare/release/dealloc_hugepages.sh" = dealloc_hugepages;
        };
      };
    };
  };

  networking = {
    firewall = {
      trustedInterfaces = [
        "virbr0"
        "macvtap1@virbr0"
      ];
    };

    networkmanager = {
      unmanaged = [
        "virbr0"
        "macvtap1@virbr0"
      ];
    };
  };
}
