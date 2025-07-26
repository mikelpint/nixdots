{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ transmission_4-gtk ];
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
