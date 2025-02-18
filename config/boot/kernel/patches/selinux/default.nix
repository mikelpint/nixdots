{ lib, config, pkgs, ... }: {
  nixpkgs = {
    overlays = [
      (_self: _super: {
        selinux = pkgs.linuxPackagesFor
          (config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              SECURITY_SELINUX = yes;
              SECURITY_SELINUX_BOOTPARAM = no;
              SECURITY_SELINUX_DISABLE = no;
              SECURITY_SELINUX_DEVELOP = yes;
              SECURITY_SELINUX_AVC_STATS = yes;
              SECURITY_SELINUX_CHECKREQPROT_VALUE = 0;
              DEFAULT_SECURITY_SELINUX = no;
            };

            ignoreConfigErrors = true;
          });
      })
    ];
  };
}
