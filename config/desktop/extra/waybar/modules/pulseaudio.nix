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

    # ignored-sinks = [ "Easy Effects Sink" ];
  }
  // (
    let
      find =
        x:
        let
          name = if lib.attrsets.isDerivation x then lib.getName x else null;
          pavucontrol = lib.getName pkgs.pavucontrol;
        in
        name == pavucontrol;
      pavucontrol = lib.lists.findFirst find (lib.lists.findFirst find null
        osConfig.environment.systemPackages
      ) config.home.packages;
    in
    lib.optionalAttrs (pavucontrol != null) {
      on-click = "${lib.getBin pavucontrol}/bin/pavucontrol &";
    }
  );
}
