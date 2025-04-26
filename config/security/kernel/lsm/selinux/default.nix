{
  pkgs,
  config,
  lib,
  ...
}:
let
  ifnotapparmor = lib.mkIf (!config.security.apparmor.enable);
in
{
  imports = [ ../../../../boot/kernel/patches/selinux ];

  systemd = ifnotapparmor {
    package = pkgs.systemd.override { withSelinux = true; };
  };

  environment = ifnotapparmor {
    systemPackages = with pkgs; [ policycoreutils ];
  };

  boot = ifnotapparmor {
    kernelParams = [
      # "lsm=selinux"
      # "security=selinux"
    ];
  };
}
