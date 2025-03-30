{ pkgs, config, ... }:
let pspkgs = config.services.postgresql.package.pkgs;
in {
  imports = [ ../postgresql ];

  environment = {
    systemPackages = with pkgs;
      with pspkgs; [
        timescaledb
        timescaledb-tune
        timescaledb-parallel-copy
        timescaledb_toolkit
      ];
  };

  services = {
    postgresql = {
      extensions = ps: with ps; [ timescaledb timescaledb_toolkit ];
      settings = { shared_preload_libraries = [ "timescaledb" ]; };
    };
  };
}
