{ lib, pkgs, config, ... }:
let
  config = {
    console = {
      packages = with pkgs; [ terminus_font ];
      font = lib.mkDefault
        "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      earlySetup = lib.mkDefault true;
    };
  };
in config
