{ pkgs, ... }:
let
  transmission = pkgs.transmission_4-gtk;
in
{
  home = {
    packages = [ transmission ];
  };

  xdg = {
    mimeApps = {
      enable = true;

      associations = {
        added = {
          "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
        };
      };

      defaultApplications = {
        "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
      };
    };
  };
}
