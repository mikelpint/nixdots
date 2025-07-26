_: {
  "battery" = {
    interval = 5;

    full-at = 99;
    states = {
      warning = 30;
      critical = 15;
    };

    format = "{icon} {capacity}%";
    tooltip-format = "{time} {capacity}%";
    format-charging = "󰂄 {capacity}%";
    format-plugged = "";
    format-alt = "{time} {icon}";
    format-icons = [
      "󰂎"
      "󰁺"
      "󰁻"
      "󰁼"
      "󰁽"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰂂"
      "󰁹"
    ];
  };
}
