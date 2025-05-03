{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        k3b = {
          executable = "${lib.getBin pkgs.kdePackages.k3b}/bin/imv";
          profile = "${pkgs.firejail}/etc/firejail/imv.profile";
        };
      };
    };
  };
}
