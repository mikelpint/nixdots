# https://raw.githubusercontent.com/Ruixi-rebirth/flakes/9e7fe7b2a40c4ae0d86f67898eed9f82e7d859e2/home/wall/default.nix

{
  pkgs,
  inputs,
  self,
  ...
}:

let
  wallpaper = "${self}/assets/wallpapers/gif/wallpaper.gif";
  swww = inputs.swww.packages.${pkgs.system}.swww or pkgs.swww;
in
{
  home = {
    packages = [ swww ];
  };

  systemd = {
    user = {
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

            ExecPreStart = "${swww}/bin/sww kill";
            ExecStart = "${swww}/bin/swww-daemon --no-cache --format xrgb --layer background";
            ExecStop = "${swww}/bin/swww kill";

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
            ExecStart = ''${swww}/bin/swww img "${wallpaper}"'';

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
