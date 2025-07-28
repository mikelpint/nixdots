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
        x86_native_cpu = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_X86_NATIVE_CPU = yes;
            };

            ignoreConfigErrors = false;
          }
        );
      })
    ];
  };
}
