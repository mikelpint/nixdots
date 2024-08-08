{ pkgs, lib, ... }: {
  boot = {
    initrd = { kernelModules = [ "amdgpu kvm-amd" ]; };

    blacklistedKernelModules = [ "radeon" ];

    extraModprobeConfig = ''
      options radeon si_support=0
      options radeon cik_support=0

      options amdgpu si_support=0
      options amdgpu cik_support=0
    '';
  };

  services = { xserver = { videoDrivers = lib.mkForce [ "amdgpu" ]; }; };
}
