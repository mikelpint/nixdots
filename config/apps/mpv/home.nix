{ pkgs, osConfig, ... }:
{
  nixpkgs = {
    overlays = [
      (_self: super: {
        mpv = super.mpv.override {
          scripts = with pkgs.mpvScripts; [
            # autosubsync-mpv
            mpv-cheatsheet
            mpv-discord
            eisa01.smartskip
            evafast
            memo
            modernz
            mpris
            mpv-image-viewer.detect-image
            mpv-image-viewer.equalizer
            mpv-image-viewer.freeze-window
            mpv-image-viewer.image-positioning
            mpv-image-viewer.minimap
            mpv-image-viewer.ruler
            mpv-image-viewer.status-line
            mpv-notify-send
            quack
            quality-menu
            sponsorblock
            thumbfast
            visualizer
            webtorrent-mpv-hook
            youtube-upnext
          ];
        };
      })
    ];
  };

  home = {
    packages = with pkgs; [ mpv ];
  };

  catppuccin = {
    mpv = {
      inherit (osConfig.catppuccin) enable flavor accent;
    };
  };

  xdg = {
    mimeApps = {
      enable = true;

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
