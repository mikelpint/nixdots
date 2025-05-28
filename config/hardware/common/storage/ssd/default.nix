{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    fstrim = {
      enable = true;
    };

    zfs = {
      trim = {
        enable = true;
      };
    };

    smartd = {
      enable = true;
      autodetect = lib.mkDefault true;

      notifications = {
        wall = {
          enable = lib.mkDefault true;
        };

        x11 = {
          enable = lib.mkDefault true;
          display = ":${toString config.services.xserver.display}";
        };

        systembus-notify = {
          enable = lib.mkDefault true;
        };

        mail = {
          enable = lib.mkDefault config.programs.msmtp.enable;
          recipient = lib.mkDefault "root";
          sender = lib.mkDefault "root";
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ smartmontools ];
  };
}
