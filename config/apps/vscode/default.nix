{ pkgs, lib, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        code = {
          executable = "${lib.getBin pkgs.vscode-fhs}/bin/code";
          profile = "${pkgs.firejail}/etc/firejail/code.profile";
        };
      };
    };
  };
}
