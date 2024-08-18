{ config, lib, ... }:
{
  environment = {
    sessionVariables = lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
      GBM_BACKEND = lib.mkForce "nvidia-drm";
      VDPAU_DRIVER = lib.mkForce "nvidia";
      LIBVA_DRIVER_NAME = lib.mkForce "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "nvidia";
      NVD_BACKEND = lib.mkForce "direct";
    };
  };
}
