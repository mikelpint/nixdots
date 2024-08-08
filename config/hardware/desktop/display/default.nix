{
  boot = {
    kernelParams = [ "video=DP-1:2560x1440@59.95" "video=DP-2:1920x1080@165" ];

    loader = { grub = { gfxmodeEfi = "2560x1440x32"; }; };
  };

  services = {
    autorandr = {
      enable = true;

      profiles = {
        desktop = {
          config = {
            DP-1 = {
              enable = true;
              primary = true;

              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
            };

            DP-2 = {
              enable = true;

              mode = "1920x1080";
              position = "2560x0";
              rate = "165.00";
            };
          };
        };
      };
    };
  };
}
