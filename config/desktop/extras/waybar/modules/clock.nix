{
  "clock" = {
    interval = 1;

    format = "󰥔 {:%T}";
    format-alt = " {:%d/%m/%Y}";

    tooltip = true;
    tooltip-format = "<tt><small>{calendar}</small></tt>";

    calendar = {
      mode = "year";

      mode-mon-col = 3;
      wweeks-pos = "right";

      on-scroll = 1;

      format = {
        months = "<span color='#f4dbd6'><b>{}</b></span>";
        days = "<span color='#f5bde6'><b>{}</b></span>";
        weeks = "<span color='#8bd5ca'><b>W{}</b></span>";
        weekdays = "<span color='#eed49f'><b>{}</b></span>";
        today = "<span color='#ed8796'><b>{}</b></span>";
      };
    };

    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_down";
      on-scroll-down = "shift_up";
    };
  };
}
