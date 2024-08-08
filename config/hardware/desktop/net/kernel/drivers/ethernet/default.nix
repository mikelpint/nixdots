{ config, lib, pkgs, ... }: {
  boot = {
    extraModulePackages = [
      (lib.hiPrio (pkgs.callPackage ../../../../../../pkgs/realtek {
        inherit (config.boot.kernelPackages) kernel;
      }).overrideAttrs (prev: { patches = [ ./r8169.patch ]; }))
    ];
  };
}
