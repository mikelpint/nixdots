{ lib, pkgs, ... }:
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

          unixSocket = "/var/run/redis.sock";
          unixSocketPerm = 660;

          inherit user;
          group = user;

          save = [ ];

          syslog = true;
          logfile = lib.mkDefault "/var/log/redis.log";
        };
      };
    };
  };
}
