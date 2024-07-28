{ pkgs, ... }: {
  boot = {
    initrd = { kernelModules = [ "amdgpu" ]; };

    blacklistedKernelModules = [ "radeon" ];

    extraModprobeConfig = ''
      options radeon si_support=0
      options radeon cik_support=0

      options amdgpu si_support=0
      options amdgpu cik_support=0
    '';
  };

  services = { xserver = { videoDrivers = [ "amdgpu" ]; }; };

  systemd = {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [ rocmPackages.hipcc rocm-opencl-icd amdvlk ];

      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };
}
