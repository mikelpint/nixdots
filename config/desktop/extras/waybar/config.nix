_: {
  mainBar = {
    layer = "top";
    position = "top";
    mod = "dock";

    modules-left =
      [ "custom/launcher" "hyprland/workspaces" "cpu" "memory" "filesystem" ];
    modules-right = [ "tray" "network" "pulseaudio" "clock" ];

    "custom/launcher" = {
      format = "󱗼";
      tooltip = false;
      on-click-release = "bemenu-run";
    };

    "hyprland/workspaces" = {
      active-only = false;
      on-click = "activate";

      disable-scroll = false;
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";

      format = "{icon}";
      format-icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
        "10" = "0";

        sort-by-number = true;
      };
    };

    "custom/media" = {
      "format" = " {}";
      "max-lenght" = "40";
      "interval" = "1";
      "exec" = "playerctl metadata --format '{{ artist }} - {{ title }}'";
      "on-click" = "playerctl play-pause";
      "on-click-right" = "playerctl stop";
      "smooth-scrolling-threshold" = "4";
      "on-scroll-up" = "playerctl next";
      "on-scroll-down" = "playerctl previous";
    };

    "tray" = {
      spacing = "10";
      icon-size = "13";
    };

    "clock" = {
      format = "{:󰥔 %T} ";
      tooltip = true;
      on-click = "";
    };

    "cpu" = {
      format = " {usage}%";
      tooltip = false;
      interval = 2;
      on-click = "wezterm -e btop";
      on-click-right = "wezterm -e fastfetch";
    };

    "memory" = {
      format = " {}%";
      on-click = "wezterm -e btop";
    };

    "backlight" = {
      format = "{icon}{percent}%";
      format-icons = [ "󰃞 " "󰃟 " "󰃠 " ];
      on-scroll-up = "light -A 1";
      on-scroll-down = "light -U 1";
    };

    "battery" = {
      interval = 30;

      full-at = 99;
      states = {
        warning = 30;
        critical = 15;
      };

      format = "{icon}{capacity}%";
      tooltip-format = "{time} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = " ";
      format-alt = "{time} {icon}";
      format-icons = [ "  " "  " "  " "  " "  " ];
    };

    "network" = {
      format-wifi = "󰖩 {essid}";
      format-ethernet = "󰈀 ";
      format-linked = "{ifname} (No IP) 󰈀 ";
      format-disconnected = "󰖪  Disconnected";
      on-click = "wezterm -e nmtui";
      tooltip-format = "{essid} {signalStrength}%";
    };

    "pulseaudio" = {
      format = "{icon}";
      format-muted = " 󰝟 ";
      format-icons = { default = [ "  " "  " "  " ]; };
      on-click = "pavucontrol &";
    };

    "custom/powermenu" = {
      format = " ";
      on-click = "$HOME/.config/rofi/powermenu/powermenu.sh";
    };
  };
}
