{ config, ... }: {
  home = {
    sessionVariables = {
      WGETRC = "${config.home.sessionVariables.XDG_CONFIG_HOME}/wgetrc";
    };
  };
}
