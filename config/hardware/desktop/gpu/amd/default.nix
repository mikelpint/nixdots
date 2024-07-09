{
  boot = { initrd = { kernelModules = [ "amdgpu" ]; }; };

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
