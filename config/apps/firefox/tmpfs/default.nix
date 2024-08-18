{
  systemd = {
    user = {
      services = {
        firefox-profile = {
          enable = true;

          description = "Sync Firefox profile to disk";

          after = [ "final.target" ];
          wantedBy = [
            "graphical-session.target"
            "final.target"
          ];

          serviceConfig = {
            Type = "oneshot";

            StandardOutput = "journal";

            ExecStart = "%h/.local/bin/firefox-sync.sh mikel";
            ExecStop = "%h/.local/bin/firefox-sync.sh mikel";

            RemainAfterExit = true;
          };
        };
      };

      timers = {
        firefox-profile = {
          description = "Run %i every 30 minutes";

          wantedBy = [ "timers.target" ];

          timerConfig = {
            OnStartupSec = "30min";
            Unit = "%i.service";
          };
        };
      };
    };
  };
}
