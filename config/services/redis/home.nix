{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages = with pkgs; [
      redis
      # iredis
    ];
  };

  programs = {
    zsh = {
      oh-my-zsh = {
        plugins = lib.optional (
          let
            any = builtins.any (
              x:
              let
                redis = lib.getName pkgs.redis;
              in
              (if lib.attrsets.isDerivation x then lib.getName x else null) == redis
            );
          in
          (any config.home.packages)
          || (any osConfig.environment.systemPackages)
          || (builtins.any (server: server.enabe or false) (
            lib.attrsets.attrValues (osConfig.services.redis.servers or { })
          ))
        ) "redis-cli";
      };
    };
  };
}
