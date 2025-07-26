{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs = {
    bat = {
      enable = true;
      package = pkgs.bat;

      config = {
        pager = "${lib.getBin pkgs.less}/bin/less -FR";
      };
    };
  };

  home = lib.mkIf (config.programs.bat.enable or false) {
    shellAliases = {
      cat = "bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";
    };

    sessionVariables = {
      MANPAGER = "${lib.getBin pkgs.bashInteractive}/bin/sh -c 'col -bx | ${
        lib.getBin config.programs.bat.package or pkgs.bat
      }/bin/bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };

  catppuccin = {
    bat = {
      enable = true;
      inherit (config.catppuccin) flavor;
    };
  };
}
