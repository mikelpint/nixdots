{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      dunst

      (writeShellScriptBin "hyprsetup_notifications" ''
        hyprctl dismissnotify

        pkill dunst
        dunst &
      '')
    ];
  };

  xdg = {
    configFile = {
      "dunst/dunstrc" = {
        text = ''
          [global]
          frame_color = "#8aadf4"
          separator_color= frame

          [urgency_low]
          background = "#24273a"
          foreground = "#cad3f5"

          [urgency_normal]
          background = "#24273a"
          foreground = "#cad3f5"

          [urgency_critical]
          background = "#24273a"
          foreground = "#cad3f5"
          frame_color = "#f5a97f"
        '';
      };
    };
  };
}
