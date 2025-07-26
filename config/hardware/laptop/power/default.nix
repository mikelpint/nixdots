{ lib, pkgs, ... }:
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
    services =
      builtins.listToAttrs (
        builtins.map (name: {
          inherit name;
          value = {
            wantedBy = lib.mkForce [ ];
          };
        }) services
      )
      // {
        autosuspend-keyboard = {
          enable = true;
          enableStrictShellChecks = true;

          description = "Autosuspend for USB device N-KEY Device [AsusTek Computer Inc.] (the keyboard).";

          unitConfig = {
            DefaultDependencies = "no";
          };

          after = [
            "sysinit.target"
          ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = ''
              ${lib.getBin pkgs.bashInteractive}/bin/sh -c 'echo auto | ${lib.getBin pkgs.coreutils}/bin/tee /sys/bus/usb/devices/1-3/power/control > /dev/null'
            '';
          };

          wantedBy = [ "basic.target" ];
        };
      };
  };
}
