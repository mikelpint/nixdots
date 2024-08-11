# https://wiki.archlinux.org/title/Firefox/Profile_on_RAM

{
  home = {
    file = {
      "firefox-sync" = {
        target = "/home/mikel/.local/bin/firefox-sync.sh.source";
        onChange = ''cat /home/mikel/.local/bin/firefox-sync.sh.source > /home/mikel/.local/bin/firefox-sync.sh && chmod +x /home/mikel/.local/bin/firefox-sync.sh'';
        text = ''
          #!/bin/sh

          static=static-$1
          link=$1
          volatile=/dev/shm/firefox-$1-$USER

          IFS=
          set -efu

          cd ~/.mozilla/firefox

          if [ ! -r $volatile ]; then
              mkdir -p -m0700 $volatile
          fi

          if [ "$(readlink $link)" != "$volatile" ]; then
              mv $link $static
              ln -s $volatile $link
          fi

          if [ -e $link/.unpacked ]; then
              rsync -av --delete --exclude .unpacked ./$link/ ./$static/
          else
              rsync -av ./$static/ ./$link/
              touch $link/.unpacked
          fi
        '';
      };
    };
  };

  systemd = {
    user = {
      services = {
        firefox-profile = {
          Unit = {
            Description = "Sync Firefox profile to disk.";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            Type = "oneshot";

            ExecStart = "%h/.local/bin/firefox-sync.sh mikel";
            ExecStop = "%h/.local/bin/firefox-sync.sh mikel";

            RemainAfterExit = true;
          };
        };

        firefox-profile-final = {
          Unit = {
            Description = "Run the firefox-profile service on shutdown/reboot.";
            DefaultDependencies = false;
            After = [ "final.target" ];
            Wants = [ "firefox-profile.service" ];
          };

          Install = {
            WantedBy = [ "final.target" ];
          };
        };
      };

      timers = {
        firefox-profile = {
          Unit = {
            Description = "Run firefox-profile every 30 minutes.";
          };

          Install = {
            WantedBy = [ "timers.target" ];
          };

          Timer = {
            OnStartupSec = "30min";

            Unit = "firefox-profile.service";
          };
        };
      };
    };
  };
}
