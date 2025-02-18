{ config, lib, pkgs, ... }:
let
  ifnvidia =
    lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers);
in {
  nixpkgs = ifnvidia { config = { nvidia = { acceptLicense = true; }; }; };

  environment = ifnvidia {
    sessionVariables = {
      GBM_BACKEND = lib.mkForce "nvidia-drm";
      VDPAU_DRIVER = lib.mkForce "nvidia";
      LIBVA_DRIVER_NAME = lib.mkForce "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = lib.mkForce "nvidia";
      __GL_VRR_ALLOWED = lib.mkForce "0";
      NVD_BACKEND = lib.mkForce "direct";
    };

    systemPackages = with pkgs; [ nvtop ];
  };
}
