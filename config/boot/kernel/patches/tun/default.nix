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
        tun = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_TUN = yes;
            };

            ignoreConfigErrors = true;
          }
        );
      })
    ];
  };
}
