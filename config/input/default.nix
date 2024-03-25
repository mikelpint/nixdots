{ config, lib, ... }:

{
  services = {
    xserver = {
      libinput = {
        enable = true;

        mouse = { accelProfile = "flat"; };

        touchpad = { accelProfile = "flat"; };
      };
    };
  };
}
