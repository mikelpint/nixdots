{
  home = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_DESKTOP_DIR = "$HOME";
    };

    variables = {
      LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
    };
  };
}
