{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  ifamdgpu = lib.mkIf (builtins.elem "amdgpu" config.services.xserver.videoDrivers);

  packages =
    if config.programs.hyprland.enable then
      inputs.hyprland.inputs.nixpkgs.legacyPackages."${pkgs.system}"
    else
      pkgs;
in
{
  hardware = ifamdgpu {
    amdgpu = {
      initrd = {
        enable = true;
      };

      amdvlk = {
        enable = true;
        package = packages.amdvlk or pkgs.amdvlk;

        support32Bit = {
          enable = true;
          package = packages.driversi686Linux.amdvlk or pkgs.driversi686Linux.amdvlk;
        };

        supportExperimental = {
          enable = true;
        };

        settings = {
          AllowVkPipelineCachingToDisk = 1;
          EnableVmAlwaysValid = 1;
          IFH = 0;
          IdleAfterSubmitGpuMask = 1;
          ShaderCacheMode = 1;
        };
      };
    };

    graphics = {
      extraPackages =
        with pkgs;
        with packages;
        [
          amdvlk
          # amf
        ]
        ++ (
          if packages ? rocmPackages.clr then
            with packages.rocmPackages;
            [
              clr
              clr.icd
            ]
          else if pkgs ? rocmPackages.clr then
            with pkgs.rocmPackages;
            [
              clr
              clr.icd
            ]
          else
            with pkgs;
            with packages;
            [
              rocm-opencl-icd
              rocm-opencl-runtime
            ]
        );

      extraPackages32 = with pkgs; with packages; with pkgsi686Linux; with driversi686Linux; [ amdvlk ];
    };
  };

  environment = ifamdgpu {
    systemPackages =
      with pkgs;
      with packages;
      [
        lact
        radeontop
        amdgpu_top
      ];

    sessionVariables = {
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = lib.mkForce "radeonsi";

      AMD_VULKAN_ICD = "RADV";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json";

      DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS = 1;
    };
  };

  systemd = ifamdgpu {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${
          pkgs.symlinkJoin {
            name = "rocm-combined";
            paths =
              with pkgs;
              with packages;
              with rocmPackages;
              [
                rocblas
                hipblas
                clr
              ];
          }
        }"
      ];
    };

    packages = with pkgs; with packages; [ lact ];

    services = {
      lactd = {
        enable = true;
        description = "AMDGPU Control Daemon";

        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  nixpkgs = ifamdgpu {
    overlays = [
      (_self: _super: {
        amdgpu_drm = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_DRM_AMDGPU = yes;
              CONFIG_DRM_AMDGPU_USERPTR = yes;
            };

            ignoreConfigErrors = false;
          }
        );
      })
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "amf" ];
    };
  };
}
