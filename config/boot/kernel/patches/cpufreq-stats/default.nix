{
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (_self: _super: {
        cpufreq-stats = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_CPU_FREQ_STAT = yes;
            };

            ignoreConfigErrors = true;
          }
        );
      })
    ];
  };
}
