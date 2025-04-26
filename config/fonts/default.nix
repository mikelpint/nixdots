{ lib, ... }:
{
  fonts = {
    fontconfig = {
      enable = true;

      antialias = lib.mkDefault true;

      subpixel = {
        rgba = lib.mkDefault "none";
        lcdfilter = lib.mkDefault "none";
      };

      hinting = {
        enable = lib.mkDefault false;
        autohint = lib.mkDefault false;
        style = lib.mkDefault "none";
      };
    };
  };

  environment = {
    sessionVariables = {
      FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
    };
  };
}
