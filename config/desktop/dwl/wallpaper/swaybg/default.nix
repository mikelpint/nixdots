{
  pkgs,
  self,
  ...
}:
let
  wallpaper = "${self}/assets/wallpapers/dithered/marketplace.png";
  inherit (pkgs) swaybg;
in
{
  home = {
    packages = [ swaybg ];
  };

  systemd = {
    user = {
      services = {
        wallpaper = {
          Unit = {
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Install = {
            WantedBy = [ "graphical-session.target" ];
          };

          Service = {
            Type = "simple";

            ExecPreStart = "${pkgs.procps}/bin/pkill swaybg";
            ExecStart = ''${swaybg}/bin/swaybg --image "${wallpaper}" --mode "fill" --output "*"'';
            ExecStop = "${pkgs.procps}/bin/pkill swaybg";

            Restart = "on-failure";
            StartLimitIntervalSec = 0;
            StartLimitBurst = 0;
          };
        };
      };
    };
  };
}
