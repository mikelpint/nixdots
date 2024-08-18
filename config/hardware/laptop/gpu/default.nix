_:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./amd
    ./nvidia
  ];

  system = {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          if [[ ! -h "/home/mikel/.config/hypr/card" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:06:00.0-card" "/home/mikel/.config/hypr/card"
          fi

          if [[ ! -h "/home/mikel/.config/hypr/otherCard" ]]; then
              ln -s "/dev/dri/by-path/pci-0000:01:00.0-card" "/home/mikel/.config/hypr/otherCard"
          fi
        '';
      };
    };
  };
}
