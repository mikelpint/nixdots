{ lib, inputs, ... }:
{
  nixpkgs = {
    overlays = with inputs; [
      (_final: prev: {
        sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
          pname = "sf-mono-liga-bin";
          version = "dev";
          src = sf-mono-liga-src;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R $src/*.otf $out/share/fonts/opentype/
          '';
        };
      })
    ];
  };

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
