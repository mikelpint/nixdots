{
  lib,
  pkgs,
  config,
  user,
  ...
}:
let
  sameHostAuth = "trust";
  ssl = (builtins.hasAttr "domain" config.networking) && config.networking.domain != null;
in
{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql;

      extensions =
        ps: with ps; [
          postgis
          pg_repack
        ];

      dataDir = lib.mkDefault "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";

      enableTCPIP = true;

      settings = lib.mkMerge [
        {
          port = lib.mkDefault 5432;

          log_connections = true;
          log_statement = "all";
          logging_collector = true;
          log_disconnections = true;
          log_destination = lib.mkForce "syslog";
          log_line_prefix =
            if config.services.postgresql.settings.log_destination == "syslog" then "[%p] " else "%m [%p] ";
        }

        (lib.mkIf ssl {
          ssl = lib.mkDefault ssl;
          ssl_cert_file = lib.mkDefault config.age.secrets."${config.networking.domain}.crt".path;
          ssl_key_file = lib.mkDefault config.age.secrets."${config.networking.domain}.key".path;
        })
      ];

      authentication = lib.mkOverride 10 ''
        # TYPE    DATABASE    USER    ORIGIN-ADDRESS    AUTH-METHOD    OPTIONS
          local   all         all                       trust
          local   sameuser    all                       peer           map=user_map
        # ipv4
          host    all         all     127.0.0.1/32      ${sameHostAuth}
        # ipv6
          host    all         all     ::1/128           ${sameHostAuth}
      '';

      identMap = ''
        # ArbitraryMapName    systemUser    DBUser
          user_map            root          postgres
          user_map            postgres      postgres
          user_map            ${user}       ${user}
      '';
    };
  };
}
