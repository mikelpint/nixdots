{ osConfig, user, ... }:
{
  home = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOWNLOAD_DIR = "$XDG_DESKTOP_DIR/Downloads";
      XDG_PICTURES_DIR = "$XDG_DESKTOP_DIR/Pictures";
      XDG_MUSIC_DIR = "$XDG_DESKTOP_DIR/Music";
      XDG_VIDEOS_DIR = "$XDG_DESKTOP_DIR/Videos";
      XDG_RUNTIME_DIR = "/run/user/${toString osConfig.users.users.${user}.uid}";

      LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
    };
  };
}
