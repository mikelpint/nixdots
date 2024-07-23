{
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
}
