{ pkgs, ... }:

{
  home = { packages = with pkgs; [ mpv ]; };

  xdg = {
    mimeApps = {
      associations = { added = { "video/mp4" = [ "mpv.desktop" ]; }; };

      defaultApplications = { "video/mp4" = [ "mpv.desktop" ]; };
    };
  };
}
