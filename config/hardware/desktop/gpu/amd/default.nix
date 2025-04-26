{
  lib,
  config,
  user,
  ...
}:
let
  ifamd = lib.mkIf (builtins.elem "amd" config.services.xserver.videoDrivers);
in
{
  environment = ifamd {
    sessionVariables = {
      ROC_ENABLE_PRE_VEGA = "1";
    };
  };

  system = ifamd {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          rm /home/${user}/.config/hypr/card
          rm /home/${user}/.config/hypr/otherCard

          if [[ -e "/dev/dri/by-path/pci-0000:07:00.0-card" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:07:00.0-card" "/home/${user}/.config/hypr/card"

              if [[ -e "/dev/dri/by-path/pci-0000:0d:00.0-card" ]]; then
                  ln -s "/dev/dri/by-path/pci-0000:0d:00.0-card" "/home/${user}/.config/hypr/otherCard"
              fi
          elif [[ -e "/dev/dri/by-path/pci-0000:0d:00.0-card" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:0d:00.0-card" "/home/${user}/.config/hypr/card"
          fi
        '';
      };
    };
  };

  programs = ifamd {
    corectrl = {
      enable = true;

      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xfff7ffff";
      };
    };
  };

  boot = ifamd {
    initrd = {
      kernelModules = [ "amdgpu kvm-amd" ];
    };

    blacklistedKernelModules = [ "radeon" ];

    extraModprobeConfig = ''
      options radeon si_support=0
      options radeon cik_support=0

      options amdgpu si_support=0
      options amdgpu cik_support=0

      options amdgpu ppfeaturemask=0xFFF7FFFF
    '';
  };
}
