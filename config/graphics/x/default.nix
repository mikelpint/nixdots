{ config, lib, ... }:

{
  services = {
    xserver = {
      enable = true;

      libinput = {
        enable = true;

        mouse = { accelProfile = "flat"; };
        touchpad = { accelProfile = "flat"; };
      };
    };
  };
}
