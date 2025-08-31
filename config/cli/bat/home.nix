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
    packages =
      with pkgs;
      with bat-extras;
      [
        batdiff
        batgrep
        batman
        batpipe
        batwatch
      ];

    shellAliases = {
      cat = "${lib.getBin (config.programs.bat.package or pkgs.bat)}/bin/bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";
    };

    sessionVariables = {
      MANPAGER = "${lib.getBin pkgs.bashInteractive}/bin/sh -c '${lib.getBin pkgs.util-linux}/bin/col -bx | ${
        lib.getBin (config.programs.bat.package or pkgs.bat)
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
