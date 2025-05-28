{
  lib,
  pkgs,
  config,
  ...
}:
let
  user = "redis";
in
{
  services = {
    redis = {
      package = pkgs.redis;

      vmOverCommit = true;

      servers = {
        "" = {
          enable = lib.mkDefault true;

          appendOnly = false;
          appendFsync = "everysec";

          bind = lib.mkDefault "127.0.0.1";
          port = lib.mkDefault 6379;
          openFirewall = lib.mkDefault false;

          unixSocket = "/run/redis/redis.sock";
          unixSocketPerm = 660;

          maxclients = 10000;

          inherit user;
          group = user;

          save = [ ];

          logLevel = "verbose";
          slowLogLogSlowerThan = 1000;
          slowLogMaxLen = 1024;
          syslog = true;
          # logfile = lib.mkDefault "/var/log/redis/redis.log";
        };
      };
    };
  };

  systemd =
    with config.services.redis.servers."";
    lib.mkIf (logfile != null && logfile != "" && logfile != "stdout" && logfile != "/dev/null") {
      services = {
        redis = {
          serviceConfig = {
            User = user;
            Group = group;
            StateDirectory = "redis";
            StateDirectoryMode = lib.mkForce "0750";
          };
        };
      };
    };
}
