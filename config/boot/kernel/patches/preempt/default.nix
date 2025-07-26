{
  pkgs,
  config,
  lib,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (_self: _super: {
        preempt = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_PREEMPT = yes;
            };
          }
        );
      })
    ];
  };
}
