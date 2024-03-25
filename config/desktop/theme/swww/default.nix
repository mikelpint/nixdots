# https://raw.githubusercontent.com/Ruixi-rebirth/flakes/9e7fe7b2a40c4ae0d86f67898eed9f82e7d859e2/home/wall/default.nix

{ pkgs, ... }:

let wallpaper = "../wallpapers/wallpaper.gif";
in {
  systemd = {
    user = {
      services = {
        swww = {
          Unit = {
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            Type = "simple";
            ExecStart = ''
              ${pkgs.swww}/bin/swww-daemon
            '';
            ExecStop = "${pkgs.swww}/bin/swww kill";
            Restart = "on-failure";
          };
        };

        wallpaper = {
          Unit = {
            Requires = [ "swww.service" ];
            After = [ "swww.service" ];
            PartOf = [ "swww.service" ];
          };

          Install = { WantedBy = [ "swww.service" ]; };
          Service = {
            ExecStart = ''${pkgs.swww}/bin/swww img "${wallpaper}"'';
            Restart = "on-failure";
            Type = "oneshot";
          };
        };
      };
    };
  };
}
