_: {
  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_notifications" ];

          envd = [ "HYPRLAND_NO_SD_NOTIFY,1" ];
        };
      };
    };
  };
}
