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

  systemd = {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
  };

  hardware = {
    graphics = {
      extraPackages = with pkgs; [
        libvdpau-va-gl
        vaapiVdpau
        mesa

        rocmPackages.hipcc
        rocm-opencl-icd
        amdvlk
      ];

      extraPackages32 = with pkgs;
        with pkgsi686Linux; [
          mesa
          libvdpau-va-gl
          vaapiVdpau

          driversi686Linux.amdvlk
        ];
    };
  };

  environment = {
    sessionVariables = { LIBVA_DRIVER_NAME = lib.mkForce "amdgpu"; };
  };
}
