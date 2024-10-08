{
  services = {
    dragonflydb = {
      enable = true;

      port = 6379;
      memcachePort = null;
      bind = "127.0.0.1";

      maxMemory = null;
      cacheMode = null;
      dbNum = null;
      keysOutputLimit = 8192;

      user = "dragonfly";
    };
  };
}
