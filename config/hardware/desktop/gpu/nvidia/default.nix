{ config, pkgs, lib, ... }:

let
  package = config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  hardware = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    nvidia = {
      inherit package;

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

    graphics = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
        vaapiVdpau
        mesa
        nv-codec-headers-12
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        nvidia-vaapi-driver
        mesa
        libvdpau-va-gl
        vaapiVdpau
      ];
    };
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
    };
  };

  boot = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    extraModulePackages = [ package ];

    initrd = {
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    extraModprobeConfig = ''
      options nvidia_drm modeset=0 fbdev=1
      options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
    '';
  };

  environment = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    systemPackages = with pkgs; with config.boot.kernelPackages; [ nvidia_x11 ];
  };
}
