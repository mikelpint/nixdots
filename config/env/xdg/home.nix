{
  osConfig,
  config,
  user,
  pkgs,
  ...
}:
{
  home = {
    sessionVariables = {
      LESSHISTFILE = "$XDG_CACHE_HOME/less.history";
    };

    packages = with pkgs; [
      xdg-utils
      xdg-user-dirs
      xdg-user-dirs-gtk
    ];
  };

  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

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
        XDG_CACHE_HOME = config.xdg.cacheHome or "$HOME/.cache";
        XDG_CONFIG_HOME = config.xdg.configHome or "$HOME/.config";
        XDG_DATA_HOME = config.xdg.dataHome or "$HOME/.local/share";
        XDG_STATE_HOME = config.xdg.stateHome or "$HOME/.local/state";
        XDG_BIN_HOME = "$HOME/.local/bin";
        XDG_RUNTIME_DIR = "/run/user/${toString osConfig.users.users.${user}.uid}";
      };
    };
  };
}
