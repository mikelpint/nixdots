{ pkgs, ... }:
{
  environment = {
    systemPackages = [ ];

    etc = {
      "rtirq.conf" = {
        text = ''
          RTIRQ_NAME_LIST="snd usb i8042"
          RTIRQ_PRIO_HIGH=90
          RTIRQ_PRIO_DECR=5
          RTIRQ_PRIO_LOW=51
          RTIRQ_RESET_ALL=0
          RTIRQ_NON_THREADED="rtc snd"
        '';
      };
    };
  };

  systemd = {
    services = {
      rtirq = {
        description = "IRQ thread tuning for realtime kernels";

        after = [
          "multi-user.target"
          "sound.target"
        ];

        wantedBy = [ "multi-user.target" ];

        path = with pkgs; [
          gawk
          gnugrep
          gnused
          procps
        ];

        serviceConfig = {
          User = "root";
          Type = "oneshot";
          ExecStart = "${pkgs.rtirq}/bin/rtirq start";
          ExecStop = "${pkgs.rtirq}/bin/rtirq stop";
          RemainAfterExit = true;
        };
      };
    };
  };
}
