{ lib, ... }:
let
  tracker-miner-services = [
    "fs-3"
    "store"
    "miner-fs"
    "miner-rss"
    "extract"
    "miner-apps"
    "writeback"
    "extract-3"
    "xdg-portal-3"
    "miner-fs-control-3"
  ];
in {
  services = { hdapsd = { enable = true; }; };

  systemd = {
    user = {
      services = lib.genAttrs
        (builtins.map (service: "tracker-${service}") tracker-miner-services)
        (service: { enable = false; });
    };
  };
}
