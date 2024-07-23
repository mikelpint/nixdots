{ config, pkgs, ... }:
{
  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      modesetting = {
        enable = true;
      };

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false;

      nvidiaSettings = true;
    };

    graphics = {
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
    };
  };

  services = {
    videoDrivers = [ "nvidia" ];
  };

  boot = {
    initrd = {
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      extraModProbeConfig = ''
        options nvidia_drm modeset=1 fbdev=1
        options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
      '';
    };
  };

  environment = {
    systemPackages = with pkgs; [
      nvidia-x11
      nvidia-settings
      nvidia-persistenced
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
    };
  };
}
