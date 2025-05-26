{ lib, pkgs, ... }:
{
  console = {
    keyMap = lib.mkForce "es";
  };

  services = {
    xserver = {
      xkb = lib.mkForce {
        variant = "";
        layout = "es";
      };
    };

    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", RUN+="${pkgs.coreutils}/bin/echo auto > /sys/bus/usb/devices/1-3/power/control"
      '';
    };
  };
}
