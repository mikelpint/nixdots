{ config, lib, ... }:

{
  environment = { sessionVariables = { NIXOS_OZONE_WL = "1"; }; };

  services = {
    xserver = { enable = true; };

    greetd = {
      enable = true;
      vt = 7;

      restart = true;

      settings = {
        default_session = {
          command = "hyprland";
          user = "mikel";
        };

        initial_session = {
          command = "hyprland";
          user = "mikel";
        };
      };
    };

    displayManager = {
      enable = lib.mkForce false;

      sddm = {
        enable = false;

        wayland = { enable = true; };

        autoLogin = { relogin = true; };
      };

      autoLogin = {
        enable = true;
        user = "mikel";
      };
    };
  };
}
