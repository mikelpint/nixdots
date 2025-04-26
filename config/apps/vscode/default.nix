{ pkgs, config, ... }:
{
  programs = {
    firejail = {
      code = {
        executable = "${pkgs.vscode-fhs}/bin/code";
        profile = "${config.programs.firejail.package}/etc/firejail/code.profile";
      };
    };
  };
}
