# https://raw.githubusercontent.com/Ruixi-rebirth/flakes/9e7fe7b2a40c4ae0d86f67898eed9f82e7d859e2/home/wall/default.nix

{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (inputs.swww.packages.${pkgs.system} or pkgs) swww;
in
{
  home = lib.mkIf (config.systemd.user.services.swww.Service.enable or false) {
    packages = [
      swww
    ];
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
            enable = lib.mkDefault false;
            Type = "simple";

            ExecPreStart = "${lib.getBin swww}/bin/swww kill";
            ExecStart = "${lib.getBin swww}/bin/swww-daemon --no-cache --format xrgb --layer background";
            ExecStop = "${lib.getBin swww}/bin/swww kill";

            Restart = "on-failure";
            StartLimitIntervalSec = 0;
            StartLimitBurst = 0;
          };
        };
        wallpaper = {
          Unit = {
            Requires = [ "swww.service" ];
            After = [ "swww.service" ];
            PartOf = [ "swww.service" ];
          };

          Install = {
            WantedBy = [ "swww.service" ];
          };

          Service = {
            enable = lib.mkDefault (config.systemd.user.services.swww.Service.enable or false);
            ExecStart = lib.mkDefault ''${lib.getBin swww}/bin/swww restore'';

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
