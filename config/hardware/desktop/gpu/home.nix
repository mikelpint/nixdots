{ osConfig, ... }:

let
  isamd = builtins.elem "amdgpu" osConfig.services.xserver.videoDrivers;
in
{
  home = {
    sessionVariables = {
      MOZ_DRM_DEVICE = if isamd then "/dev/dri/card1" else "/dev/dri/card0";
    };
  };

  programs = {
    mangohud = {
      settings = {
        pci_dev = if isamd then "0000:07:00.0" else "0000:0d:00.0";
      };
    };
  };
}
