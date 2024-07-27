{ pkgs, ... }: {
  home = { packages = with pkgs; [ transmission-gtk ]; };

  services = {
    transmission = {
      settings = {
        download-dir = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
      };
    };
  };
}
