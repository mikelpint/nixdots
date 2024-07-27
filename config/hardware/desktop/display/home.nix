{ lib, ... }: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          monitor = lib.mkForce [
            "DP-0,2560x1440@59.95,0x0,1"
            "DP-1,1920x1080@165,2560x0,1"
          ];

          misc = { vfr = lib.mkForce false; };

          decoration = {
            blur = { enabled = lib.mkForce true; };

            drop_shadow = lib.mkForce true;
          };
        };
      };
    };
  };
}
