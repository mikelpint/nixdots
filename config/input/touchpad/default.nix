{ lib, ... }:
{
  services = {
    libinput = {
      enable = true;

      touchpad = {
        accelProfile = lib.mkDefault "flat";
      };
    };
  };
}
