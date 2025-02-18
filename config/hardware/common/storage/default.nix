{ lib, pkgs, ... }: {
  services = { hdapsd = { enable = lib.mkDefault false; }; };

  boot = {
    initrd = { availableKernelModules = [ "sd_mod" "ahci" ]; };

    kernelModules = [ "sg" ];
  };

  environment = {
    systemPackages = with pkgs; [
      gparted
      #k3b
      dvdplusrwtools
      (writeShellScriptBin "gparted-xhost" ''
        ${xorg.xhost}/bin/xhost +SI:localuser:root
        ${gparted}/bin/gparted
        ${xorg.xhost}/bin/xhost -SI:localuser:root
      '')
    ];

    shellAliases = { gparted = "gparted-xhost"; };
  };
}
