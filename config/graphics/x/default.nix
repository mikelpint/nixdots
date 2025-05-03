{
  lib,
  user,
  config,
  pkgs,
  ...
}:
let
  command =
    if config.programs.hyprland.withUWSM then
      ''
        [ $(uwsm check may-start) ] && \
        ${pkgs.uwsm}/bin/uwsm start hyprland.desktop
      ''
    else
      "dbus-run-session Hyprland";
in
{
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  services = {
    xserver = {
      enable = true;
    };

    greetd = {
      enable = true;
      vt = 7;

      restart = true;

      settings = {
        default_session = {
          inherit command;
          inherit user;
        };

        initial_session = {
          inherit command;
          inherit user;
        };
      };
    };

    displayManager = {
      enable = lib.mkForce false;

      sddm = {
        enable = false;

        wayland = {
          enable = true;
        };

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
          inherit (config.services.greetd) enable;
          enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
        };
      };
    };
  };
}
