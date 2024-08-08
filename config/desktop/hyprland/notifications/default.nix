{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      [
        (writeShellScriptBin "hyprsetup_notifications" ''
          hyprctl dismissnotify

          pkill dunst
          dunst &
        '')
      ];
  };

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