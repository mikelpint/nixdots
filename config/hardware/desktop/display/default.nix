{ config, lib, ... }:
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
    display = {
      outputs = {
        "DP-1" = mkifnvidia { edid = "VG24VQE.bin"; };

        "DP-2" = mkifamd { edid = "VG24VQE.bin"; };
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
