{ inputs, pkgs, ... }:

{
  imports = [
    ./amd
    ./nvidia
    ./vfio
  ];

  system = {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          if [[ ! -h "/home/mikel/.config/hypr/card" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:06:00.0-card" "/home/mikel/.config/hypr/card"
          fi
        '';
      };
    };
  };

  environment = {
    variables = {
      __GL_VRR_ALLOWED = "0";
    };
  };
}
