{ config, home-manager, ... }:
{
  home = {
    sessionVariables = {
      WGETRC = "${config.home.sessionVariables.XDG_CONFIG_HOME or "\${XDG_CONFIG_HOME}"}/wgetrc";
    };

    activation = {
      "create-wgetrc" = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
        [ ! -f ${config.home.sessionVariables.WGETRC} ] && mkdir -p "$(dirname "${config.home.sessionVariables.WGETRC}")" && touch "${config.home.sessionVariables.WGETRC}"
      '';
    };
  };
}
