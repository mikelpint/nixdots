{ config, pkgs, lib, user, ... }:

let
  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  ifnvidia =
    lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers);
in {
  system = ifnvidia {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          if [[ ! -h "/home/${user}/.config/hypr/card" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:0d:00.0-card" "/home/${user}/.config/hypr/card"
          fi
        '';
      };
    };
  };

  hardware = ifnvidia {
    nvidia = {
      inherit package;

      modesetting = { enable = true; };

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;

      nvidiaSettings = true;
    };

    graphics = ifnvidia {
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
        vaapiVdpau
        mesa
        mesa.drivers
        nv-codec-headers-12
        egl-wayland
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
        mesa
        mesa.drivers
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
  };

  boot = ifnvidia {
    extraModulePackages = [ package ];

    initrd = {
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };

    extraModprobeConfig = ''
      options nvidia_drm modeset=0 fbdev=1
      options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
    '';
  };

  environment = ifnvidia {
    systemPackages = with pkgs; with config.boot.kernelPackages; [ nvidia_x11 ];
  };
}
