{
  boot = {
    initrd = {
      kernelModules = [ "amdgpu radeon" ];

      extraModProbeConfig = ''
        options radeon si_support=0
        options radeon cik_support=0

        options amdgpu si_support=0
        options amdgpu cik_support=1
      '';
    };
  };

  services = { videoDrivers = [ "amdgpu" ]; };

  systemd = {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
  };

  hardware = {
    opengl = {
      extraPackages = [ pkgs.rocmPackages.hip rocm-opencl-icd amdvlk ];

      extraPackages32 = [ driversi686Linux.amdvlk ];
    };
  };
}
