{ pkgs, ... }:
{
  imports = [ ../../../../../config/boot/kernel/patches/cpufreq-stats ];

  powerManagement = {
    powertop = {
      enable = false;
    };
  };

  environment = {
    systemPackages = with pkgs; [ powertop ];
  };

  boot = {
    kernelModules = [
      "cpufreq_stats"
    ];
  };
}
