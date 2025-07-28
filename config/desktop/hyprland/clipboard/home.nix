{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../extra/wofi/home.nix ];

  home = {
    packages = with pkgs; [ cliphist ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = lib.lists.flatten (
            lib.attrsets.mapAttrsToList
              (
                main: subs:
                builtins.map (type: "wl-paste --type ${type} --watch cliphist store") (
                  builtins.map (sub: "${main}/${sub}") (if builtins.isList subs then subs else [ subs ]) ++ [ main ]
                )
              )
              {
                "text" = [
                  "plain"
                  "plain;charset=utf-8"
                  "html"
                  # "_moz_htmlcontext"
                  # "_moz_htmlinfo"
                  "x-moz-url-priv"
                  "ico"
                ];

                "image" = [
                  "jpeg"
                  "png"
                  "tiff"
                  "icon"
                  "ico"
                  "vnd.microsoft.icon"
                  "x-win-bitmap"
                  "x-ico"
                  "x-icon"
                  "x-MS-bmp"
                  "x-bmp"
                  "bmp"
                  "gif"
                ];

                "application" = [ "ico" ];
              }
          );

          bind = lib.optionals (config.programs.wofi.enable or false) [
            "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
          ];
        };
      };
    };
  };
}
