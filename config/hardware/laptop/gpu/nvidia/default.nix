{
  hardware = {
    nvidia = {
      prime = {
        amdgpuBusId = "PCI:06:00:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };

  system = {
    userActivationScripts = {
      hyprgpu = {
        text = ''
          if [[ ! -h "$HOME/.config/hypr/card" ]]; then
            ln -s "$HOME/.config/hypr/card" "/dev/dri/by-path/pci-0000:06:00.0-card"
          fi

          if [[ ! -h "$HOME/.config/hypr/otherCard" ]]; then
            ln -s "$HOME/.config/hypr/otherCard" "/dev/dri/by-path/pci-0000:01:00.0-card"
          fi
        '';
      };
    };
  };

  boot = {
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    blacklistedKernelModules =
      [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  };

  services = {
    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
    };
  };
}
