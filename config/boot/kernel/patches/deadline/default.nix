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
        deadline = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_IOSCHED_DEADLINE = y;
              CONFIG_DEFAULT_DEADLINE = y;
              CONFIG_DEFAULT_IOSCHED = "deadline";
            };
          }
        );
      })
    ];
  };
}
