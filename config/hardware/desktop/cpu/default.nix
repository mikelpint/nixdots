{
  config,
  ...
}:

{
  imports = [
    ../../common/cpu/vendor/amd
    ../../common/cpu/realtime

    ../../../boot/kernel/patches/preempt
    ../../../boot/kernel/patches/native/x86
  ];

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kernel ];

    kernel = {
      sysctl = {
        "kernel.sched_cfs_bandwith_slice_us" = 5000;
      };
    };

    kernelParams = [ "amd_pstate=guided" ];
  };

  nix = {
    settings = {
      max-jobs = 24;
    };
  };
}
