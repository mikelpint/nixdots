{ pkgs, ... }:
{
  imports = [ ../../../../boot/kernel/patches/selinux ];

  systemd = {
    package = pkgs.systemd.override { withSelinux = true; };
  };

  environment = {
    systemPackages = with pkgs; [ policycoreutils ];
  };

  boot = {
    kernelParams = [
      "lsm=selinux"
      "security=selinux"
    ];
  };
}
