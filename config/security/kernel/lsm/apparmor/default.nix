{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../../../boot/kernel/patches/apparmor ];

  security = {
    apparmor = {
      enable = true;
      enableCache = true;

      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
        apparmor-pam
      ];

      killUnconfinedConfinables = true;
    };
  };

  boot = lib.mkIf (config.security.apparmor.enable or false) {
    kernelParams = [
      "apparmor=1"
    ];
  };
}
