{ lib, pkgs, ... }:
{
  console = {
    packages = with pkgs; [ terminus_font ];
    font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    earlySetup = lib.mkDefault true;
  };

  services = {
    xserver = {
      dpi = lib.mkDefault 300;
    };

    displayManager = {
      sddm = {
        enableHidpi = lib.mkDefault true;
      };
    };
  };
}
