{
  systemd = {
    services = {
      "getty@tty1" = {
        serviceConfig = {
          ExecStart = "-/usr/bin/agetty --skip-login --nonewline --noissue --autologin mikel --noclear %I $TERM";
          Type = "idle";
        };
      };
    };
  };
}
