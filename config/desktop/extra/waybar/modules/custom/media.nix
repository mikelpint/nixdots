{
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
}
