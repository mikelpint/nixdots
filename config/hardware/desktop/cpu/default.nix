{ config, lib, pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      (self: super: {
        preempt = pkgs.linuxPackagesFor
          (pkgs.linuxPackages_latest.kernel.override {
            structuredExtraConfig = with lib.kernel; { CONFIG_PREEMPT = yes; };
            ignoreConfigErrors = true;
          });
      })
    ];
  };

  hardware = {
    cpu = {
      amd = {
        updateMicrocode =
          lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    };
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kernel ];

    kernel = { sysctl = { "kernel.sched_cfs_bandwith_slice_us" = 5000; }; };
  };
}
