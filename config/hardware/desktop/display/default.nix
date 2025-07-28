{
  config,
  lib,
  pkgs,
  self,
  ...
}:
let
  isnvidia = builtins.elem "nvidia" config.services.xserver.videoDrivers;
  isamd = builtins.elem "amdgpu" config.services.xserver.videoDrivers;

  mkifnvidia = lib.mkIf isnvidia;
  mkifamd = lib.mkIf isamd;
in
{
  boot = {
    kernelParams =
      if isamd then
        [
          "video=DP-1:2560x1440@59.95"
          "video=DP-2:1920x1080@165"
        ]
      else
        [
          "video=DVI-D-1:2560x1440@59.91"
          "video=DP-1:1920x1080@59.96"
        ];

    loader = {
      grub = {
        gfxmodeEfi = "2560x1440x32";
      };
    };
  };

  hardware = {
    display = lib.mkIf false {
      edid = {
        enable = true;
        packages = [
          (pkgs.runCommand "edid-custom" { } ''
            mkdir -p "$out/lib/firmware/edid"
            ${lib.strings.concatLines (
              builtins.map
                (edid: ''
                  sed -rzE \
                    's/EDID \(hex\):\n(([0-9a-fA-F]+\n)+)\n.*/\1/g' \
                    < "${self}/config/hardware/desktop/display/edid/${edid}" | \
                  base64 -d > $out/lib/firmware/edid/${edid}
                '')
                [
                  "ETLAL03385010"
                  "M3LMTF048855"
                ]
            )}
          '')
        ];
      };

      outputs = {
        "DVI-D-1" = mkifnvidia { edid = "ETLAL03385010.bin"; };
        "DP-1" = mkifamd { edid = "ETLAL03385010.bin"; } // (mkifnvidia { edid = "M3LMTF048855.bin"; });
        "DP-2" = mkifamd { edid = "M3LMTF048855.bin"; };
      };
    };
  };

  services = {
    xserver = {
      deviceSection = mkifamd ''
        Option "TearFree" "False"
        Option "VariableRefresh" "True"
      '';
    };

    autorandr = {
      enable = true;

      profiles = {
        desktop = {
          config =
            if isamd then
              {
                DP-1 = {
                  enable = true;
                  primary = true;

                  mode = "2560x1440";
                  position = "0x0";
                  rate = "59.95";
                };

                DP-2 = {
                  enable = true;

                  mode = "1920x1080";
                  position = "2560x0";
                  rate = "165.00";
                };
              }
            else
              {
                DVI-D-1 = {
                  enable = true;
                  primary = true;

                  mode = "2560x1440";
                  position = "0x0";
                  rate = "59.91";
                };

                DP-1 = {
                  enable = true;

                  mode = "1920x1080";
                  position = "2560x0";
                  rate = "59.96";
                };
              };
        };
      };
    };
  };
}
