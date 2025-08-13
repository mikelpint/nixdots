{
  config,
  pkgs,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (_self: _super: {
        _rust = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            withRust = true;

            ignoreConfigErrors = false;
          }
        );
      })
    ];
  };
}
