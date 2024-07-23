# https://raw.githubusercontent.com/Ruixi-rebirth/flakes/9e7fe7b2a40c4ae0d86f67898eed9f82e7d859e2/home/wall/default.nix

{ pkgs, ... }:

let
  wallpaper = "/etc/nixos/config/desktop/theme/wallpapers/wallpaper.gif";
in
{
  home = {
    packages = with pkgs; [ swww ];
  };

  systemd = {
    user = {
      #timers = {
      #  wallpaper = {
      #    Install = { WantedBy = [ "timers.target" ]; };
      #    
      #    Timer = {
      #      OnBootSec = "1s";
      #      Unit = "wallpaper.service";
      #    };
      #  }; 
      #}; 

      services = {
        swww = {
          Unit = {
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };

          Service = {
            Type = "simple";

            ExecStart = ''${pkgs.swww}/bin/swww-daemon --no-cache'';
            ExecStop = "${pkgs.swww}/bin/swww kill";

            Restart = "on-failure";
            StartLimitIntervalSec = 0;
            StartLimitBurst = 0;
          };
        };

        wallpaper = {
          Unit = {
            Requires = [ "swww.service" ];
            After = [
              "swww.service"
              "hyprland-session.target"
            ];
            PartOf = [ "swww.service" ];
          };

          Install = {
            WantedBy = [
              "swww.service"
              "hyprland-session.target"
            ];
          };

          Service = {
            ExecStart = ''${pkgs.swww}/bin/swww img "${wallpaper}"'';

            Restart = "on-failure";
            StartLimitIntervalSec = 0;
            StartLimitBurst = 0;

            Type = "oneshot";
          };
        };
      };
    };
  };
}
