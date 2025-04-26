{ pkgs, ... }:
{
  programs = {
    firejail = {
      wrappedBinaries = {
        code = {
          executable = "${pkgs.vscode-fhs}/bin/code";
          profile = "${pkgs.firejail}/etc/firejail/code.profile";
        };
      };
    };
  };
}
