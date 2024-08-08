{ config, lib, pkgs, ... }:

{
  imports = [ ../../common/cpu/vendor/amd ];

  nixpkgs = {
    overlays = [
      (self: super: {
        preempt = pkgs.linuxPackagesFor
          (config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; { CONFIG_PREEMPT = yes; };

            ignoreConfigErrors = true;
          });
      })
    ];
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kernel ];

    kernel = { sysctl = { "kernel.sched_cfs_bandwith_slice_us" = 5000; }; };
    kernelParams = [ "amd_pstate=guided" ];
  };

  nix = { settings = { cores = 6; }; };
}
