{
  "disk" = {
    interval = 60;

    path = "/";

    states = {
      warning = 70;
      critical = 90;
    };

    format = " {percentage_used}%";

    on-click = "wezterm -e ncdu / -q -2 -t $(nproc) --exclude-kernfs";
  };
}
