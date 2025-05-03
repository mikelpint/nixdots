{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        imv = {
          executable = "${lib.getBin pkgs.imv}/bin/imv";
          profile = "${pkgs.firejail}/etc/firejail/imv.profile";
        };
      };
    };
  };
}
