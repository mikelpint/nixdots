{ config, lib, ... }: {
  environment = {
    sessionVariables =
      lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
  };
}
