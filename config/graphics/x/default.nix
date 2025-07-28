{
  lib,
  user,
  config,
  ...
}:
{
  services = {
    xserver = {
      enable = true;
    };

    greetd = {
      enable = lib.mkDefault true;
      vt = lib.mkDefault 7;

      restart = true;

      settings = {
        default_session = {
          inherit user;
        };

        initial_session = {
          inherit user;
        };
      };
    };

    displayManager = {
      enable = lib.mkForce false;

      sddm = {
        enable = false;

        autoLogin = {
          relogin = true;
        };
      };

      autoLogin = {
        enable = true;
        inherit user;
      };
    };
  };

  security = {
    pam = {
      services = {
        greetd = {
          inherit (config.services.greetd or { enable = false; }) enable;
          enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
        };
      };
    };
  };
}
