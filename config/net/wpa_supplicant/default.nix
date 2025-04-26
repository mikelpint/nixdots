{ lib, config, ... }:
{
  networking = {
    wireless = {
      enable = false;

      userControlled = {
        enable = true;
      };
    };

    networkmanager = lib.mkIf config.networking.wireless.enable {
      unmanaged = [
        "*"
        "except:type:wwan"
        "except:type:gsm"
      ];
    };
  };
}
