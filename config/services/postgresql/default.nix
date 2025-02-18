{ lib, pkgs, config, ... }:
let sameHostAuth = "trust";
in {
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql;

      extensions = ps: with ps; [ postgis pg_repack ];

      dataDir =
        "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";

      enableTCPIP = true;

      settings = {
        ssl = false;
        port = 5432;

        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        log_destination = lib.mkForce "syslog";
        log_line_prefix = if config.services.postgresql.settings.log_destination
        == "syslog" then
          "[%p] "
        else
          "%m [%p] ";
      };

      authentication = lib.mkOverride 10 ''
        # TYPE    DATABASE    USER    ORIGIN-ADDRESS    AUTH-METHOD    OPTIONS
          local   all         all                       trust
          local   sameuser    all                       peer           map=superuser_map
        # ipv4
          host    all         all     127.0.0.1/32      ${sameHostAuth}
        # ipv6
          host    all         all     ::1/128           ${sameHostAuth}
      '';

      identMap = ''
        # ArbitraryMapName    systemUser    DBUser
          superuser_map       root          postgres
          superuser_map       postgres      postgres
      '';
    };
  };
}
