{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  "pulseaudio" = {
    format = "{icon} {volume}%";
    format-muted = "󰝟";
    format-icons = {
      default = [
        ""
        ""
        " "
      ];
    };

    scroll-step = 1;
    on-click =
      let
        find =
          x:
          let
            name = if lib.attrsets.isDerivation x then lib.getName x else null;
            pavucontrol = lib.getName pkgs.pavucontrol;
          in
          name == pavucontrol;
        pavucontrol = lib.lists.findFirst find (lib.lists.findFirst find pkgs.ncdu
          osConfig.environment.systemPackages
        ) config.home.packages;
      in
      "${pavucontrol}/bin/pavucontrol &";

    # ignored-sinks = [ "Easy Effects Sink" ];
  };
}
