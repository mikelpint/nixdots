{ pkgs, ... }:

{
  programs = {
    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        advanced-scene-switcher
        droidcam-obs
        input-overlay
        obs-backgroundremoval
        obs-command-source
        obs-composite-blur
        obs-freeze-filter
        obs-gradient-source
        obs-gstreamer
        obs-move-transition
        obs-mute-filter
        obs-pipewire-audio-capture
        obs-source-clone
        obs-source-switcher
        obs-tuna
        obs-vaapi
        wlrobs
      ];
    };
  };
}
