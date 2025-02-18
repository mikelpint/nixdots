{ lib, config, pkgs, ... }: {
  nixpkgs = {
    overlays = [
      (_self: _super: {
        apparmor = pkgs.linuxPackagesFor
          (config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_SECURITY_APPARMOR = yes;
              CONFIG_AUDIT = yes;
            };

            ignoreConfigErrors = true;
          });
      })
    ];
  };
}
