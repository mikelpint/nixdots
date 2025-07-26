{ config, lib, ... }:
{
  environment = {
    sessionVariables = {
      SDL_JOYSTICK_HIDAPI = 0;
    };
  };

  hardware = {
    bluetooth = {
      settings = {
        # https://github.com/atar-axis/xpadneo/issues/166
        General = {
          JustWorksRepairing = "always";
          FastConnectable = true;
          Class = "0x000100";
        };

        GATT = {
          ReconnectIntervals = "1,1,2,3,5,8,13,21,34,55";
          AutoEnable = true;
        };
      };
    };

    xpadneo = {
      enable = lib.mkDefault (!config.hardware.xone.enable);
    };

    xone = {
      enable = lib.mkDefault true;
    };
  };

  boot = {
    kernelParams = [
      "bluetooth.disable_ertm=1"
      "btusb.enable_autosuspend=n"
    ];
  };

  services = {
    tlp = {
      settings = {
        USB_DENYLIST = "045e:0719";
      };
    };
  };
}
