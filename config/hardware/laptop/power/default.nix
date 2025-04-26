{ lib, ... }:
let
  services = [
    "docker"
    "mongodb"
    "postgresql"
    "redis"
  ];
in
{
  imports = [
    ./auto-cpufreq
    ./power-profiles-daemon
    ./powertop
    ./scheduling
    ./tlp
  ];

  systemd = {
    services = builtins.listToAttrs (
      builtins.map (name: {
        inherit name;
        value = {
          wantedBy = lib.mkForce [ ];
        };
      }) services
    );
  };
}
