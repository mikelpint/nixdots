{ lib, pkgs, ... }: {
  boot = {
    kernelParams = [ "video=eDP-1:1920x1080@60" ];

    loader = { grub = { gfxmodeEfi = "1920x1080x32"; }; };
  };

  programs = { light = { enable = true; }; };

  services = {
    udev = {
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amd_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
      '';
    };

    autorandr = {
      enable = true;

      profiles = {
        desktop = {
          config = {
            eDP-1 = {
              enable = true;
              primary = true;

              mode = "1920x1080";
              position = "0x0";
              rate = "60.00";
            };
          };
        };
      };
    };
  };
}
