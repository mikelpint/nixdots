{ pkgs, ... }:
let
    inherit (pkgs) mpv;
in {
  nixpkgs = {
    overlays = [
      (_self: super: {
        mpv = super.mpv.override {
          scripts = with pkgs.mpvScripts; [
            autosubsync-mpv
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
    packages = [ mpv ];
  };

  xdg = {
    configFile = {
      "mpv/mpv.conf" = {
        text = ''
          background-color='#24273a'
          osd-back-color='#181926'
          osd-border-color='#181926'
          osd-color='#cad3f5'
          osd-shadow-color='#24273a'

          script-opts-append=stats-border_color=30201e
          script-opts-append=stats-font_color=f5d3ca
          script-opts-append=stats-plot_bg_border_color=e6bdf5
          script-opts-append=stats-plot_bg_color=30201e
          script-opts-append=stats-plot_color=e6bdf5

          script-opts-append=uosc-color=foreground=f5bde6,foreground_text=363a4f,background=24273a,background_text=cad3f5,curtain=1e2030,success=a6da95,error=ed8796
        '';
      };
    };

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
