{
  "pulseaudio" = {
    format = "{icon} {volume}%";
    format-muted = "󰝟";
    format-icons = {
      default = [
        ""
        ""
        " "
      ];
    };

    scroll-step = 1;
    on-click = "pavucontrol &";

    ignored-sinks = [ "Easy Effects Sink" ];
  };
}
