{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ ../rust ];

  nixpkgs = {
    overlays = [
      (_self: _super: {
        preempt = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              DRM_PANIC_SCREEN_QR_CODE = yes;
            };

            ignoreErrors = true;
          }
        );
      })
    ];
  };
}
