{ lib, pkgs, ... }:
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
  environment = { systemPackages = with pkgs; [ hdapsd ]; };

  boot = {
    kernelModules = [ "hdapsd" ];
    extraModulePackages = with pkgs; [ hdapsd ];
  };

  services = {
    udev = { packages = with pkgs; [ hdapsd ]; };

    hdapsd = { enable = true; };
  };

  systemd = {
    packages = with pkgs; [ hdapsd ];

    user = {
      services = lib.genAttrs
        (builtins.map (service: "tracker-${service}") tracker-miner-services)
        (_service: { enable = false; });
    };
  };
}
