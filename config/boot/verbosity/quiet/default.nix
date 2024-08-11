{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs = {
    overlays = [
      (self: super: {
        preempt = pkgs.linuxPackagesFor (
          config.boot.kernelPackages.kernel.override {
            structuredExtraConfig = with lib.kernel; {
              CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = yes;
            };

            ignoreConfigErrors = true;
          }
        );
      })
    ];
  };

  boot = {
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
    };
    kernelParams = [
      "loglevel=3"
      "quiet"
      "rd.systemd.show_status=false"
      "udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
    ];
  };
}
