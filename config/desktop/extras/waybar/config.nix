_: {
  mainBar = {
    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "cpu"
      "memory"
      "disk"
    ];

    modules-right = [
      "tray"
      "pulseaudio"
      "network"
      "clock"
    ];

    "custom/launcher" = {
      format = " 󱗼 ";
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
        "10" = "10";

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
      format = "󰥔 {:%T} ";
      tooltip = true;
      on-click = "";
    };

    "cpu" = {
      format = " {usage}%";
      tooltip = false;

      interval = 5;
      states = {
        warning = 50;
        critical = 80;
      };

      on-click = "wezterm -e btop";
      on-click-right = "wezterm -e fastfetch";
    };

    "memory" = {
      format = " {}%";
      on-click = "wezterm -e btop";
    };

    "disk" = {
      interval = "60";

      path = "/";

      states = {
        warning = 70;
        critical = 90;
      };

      format = " {percentage_used}%";
    };

    "backlight" = {
      format = "{icon}{percent}%";
      format-icons = [
        "󰃞 "
        "󰃟 "
        "󰃠 "
      ];

      on-scroll-up = "light -A 1";
      on-scroll-down = "light -U 1";
    };

    "battery" = {
      interval = 5;

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
      format-icons = [
        "󰂎 "
        "󰁺 "
        "󰁻 "
        "󰁼 "
        "󰁽 "
        "󰁾 "
        "󰁿 "
        "󰂀 "
        "󰂁 "
        "󰂂 "
        "󰁹 "
      ];
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
      format-icons = {
        default = [
          "  "
          "  "
          "  "
        ];
      };

      on-click = "pavucontrol &";
    };

    "custom/powermenu" = {
      format = " ";
      on-click = "$HOME/.config/rofi/powermenu/powermenu.sh";
    };
  };
}
