{ config, lib, ... }:

{
  environment = { sessionVariables = { NIXOS_OZONE_WL = "1"; }; };

  services = {
    xserver = { enable = true; };

    displayManager = {
      sddm = {
        enable = true;
        wayland = { enable = true; };
        autoLogin = { relogin = true; };
      };

      autoLogin = {
        enable = true;
        user = "mikel";
      };
    };

    libinput = {
      enable = true;

      mouse = { accelProfile = "flat"; };
      touchpad = { accelProfile = "flat"; };
    };
  };
}
