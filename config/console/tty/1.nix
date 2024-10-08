{ pkgs, config, ... }:
{
  systemd = {
    services = {
      "getty@tty1" = {
        overrideStrategy = "asDropin";

        serviceConfig = {
          Type = "idle";

          ExecStart = [
            ""
            "-${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram}  --autologin mikel --nonewline --noissue --noclear --keep-baud 115200,38400,9600 %I $TERM"
          ];
        };
      };
    };
  };
}
