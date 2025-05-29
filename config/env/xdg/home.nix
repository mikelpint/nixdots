{
  osConfig,
  config,
  user,
  ...
}:
{
  home = {
    sessionVariables = {
      LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
    };
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = false;

      desktop = "${config.home.homeDirectory}/Desktop";
      download = "${config.home.homeDirectory}/Downloads";
      documents = "${config.home.homeDirectory}/Documents";
      pictures = "${config.home.homeDirectory}/Pictures";
      music = "${config.home.homeDirectory}/Music";
      videos = "${config.home.homeDirectory}/Music";
      publicShare = "${config.home.homeDirectory}/Public";
      templates = "${config.home.homeDirectory}/Templates";
      extraConfig = {
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_RUNTIME_DIR = "/run/user/${toString osConfig.users.users.${user}.uid}";
      };
    };
  };
}
