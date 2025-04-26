{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        k3b = {
          executable = "${pkgs.kdePackages.k3b}/bin/imv";
          profile = "${pkgs.firejail}/etc/firejail/imv.profile";
        };
      };
    };
  };
}
