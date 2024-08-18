{
  config,
  lib,
  pkgs,
  ...
}:

let
  ifamdgpu = lib.mkIf (builtins.elem "amdgpu" config.services.xserver.videoDrivers);
in
{
  hardware = ifamdgpu {
    graphics = {
      extraPackages =
        (with pkgs; [
          amdvlk

          #rocmPackages.hipcc
        ])
        ++ (
          if pkgs ? rocmPackages.clr then
            with pkgs.rocmPackages;
            [
              clr
              clr.icd
            ]
          else
            with pkgs;
            [
              rocm-opencl-icd
              rocm-opencl-runtime
            ]
        );

      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };

  environment = ifamdgpu {
    systemPackages = with pkgs; [ lact ];
    sessionVariables = {
      VDPAU_DRIVER = "radeonsi";
      LIBVA_DRIVER_NAME = lib.mkForce "amdgpu";
    };
  };

  systemd = ifamdgpu {
    tmpfiles = {
      rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${
          pkgs.symlinkJoin {
            name = "rocm-combined";
            paths = with pkgs.rocmPackages; [
              rocblas
              hipblas
              clr
            ];
          }
        }"
      ];
    };

    services = {
      lactd = {
        description = "AMDGPU Control Daemon";
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.lact}/bin/lact daemon";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
  };

  nixpkgs = ifamdgpu {
    overlays = [
      (self: super: {
        amdgpu_drm = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_DRM_AMDGPU = yes;
              CONFIG_DRM_AMDGPU_USERPTR = yes;
            };

            ignoreConfigErrors = true;
          }
        );
      })
    ];
  };
}
