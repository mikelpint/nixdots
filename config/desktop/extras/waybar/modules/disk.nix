{
  "disk" = {
    interval = "60";

    path = "/";

    states = {
      warning = 70;
      critical = 90;
    };

    format = " {percentage_used}%";
  };
}
