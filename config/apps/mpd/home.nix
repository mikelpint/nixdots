{
  pkgs,
  config,
  user,
  ...
}:
{
  services = {
    mpd = {
      enable = true;
      package = pkgs.mpd;

      dataDir = "/home/${user}/.local/share/mpd";
      # dataDir = "${config.xdg.userDirs.extraConfig.XDG_DATA_HOME or "\${XDG_DATA_HOME}"}/mpd";
      dbFile = "${config.services.mpd.dataDir}/tag_cache";
      musicDirectory = config.xdg.userDirs.music or "${config.home.homeDirectory}/Music";
      playlistDirectory = "${config.services.mpd.dataDir}/playlists";

      network = {
        listenAddress = "127.0.0.1";
        port = 6600;
        startWhenNeeded = true;
      };
    };
  };
}
