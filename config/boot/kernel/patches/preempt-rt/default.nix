{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ../preempt ];

  nixpkgs = {
    overlays = [
      (_self: _super: {
        preempt-rt = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_PREEMPT_RT = yes;
              CONFIG_PREEMPT_RT_FULL = yes;

              CONFIG_EXPERT = yes;
              CONFIG_PREEMPT_VOLUNTARY = lib.mkForce no;
              CONFIG_RT_GROUP_SCHED = lib.mkForce (option no);
            };
          }
        );
      })
    ];
  };
}
