{
  boot = {
    kernelParams = [
      "video=DP-0:2560x1440@165"
      "video=DP-1:1920x1080@60"
    ];
  };

  services = {
    autorandr = {
      enable = true;

      profiles = {
        desktop = {
          config = {
            DP-0 = {
              enable = true;
              primary = true;

              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
            };

            DP-1 = {
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
