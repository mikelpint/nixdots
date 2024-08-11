{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ mpv ];
  };

  programs = {
    mpv = {
      catppuccin = {
        enable = true;

        flavor = "macchiato";
        accent = "pink";
      };
    };
  };

  xdg = {
    mimeApps = {
      associations = {
        added = {
          "video/mp4" = [ "mpv.desktop" ];
        };
      };

      defaultApplications = {
        "video/mp4" = [ "mpv.desktop" ];
      };
    };
  };
}
