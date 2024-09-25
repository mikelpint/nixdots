{ pkgs, ... }:
{
  imports = [ ../../../../boot/kernel/patches/apparmor ];

  security = {
    apparmor = {
      enable = true;

      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };
  };

  boot = {
    kernelParams = [
      "lsm=apparmor"
      "security=apparmor"
    ];
  };
}
