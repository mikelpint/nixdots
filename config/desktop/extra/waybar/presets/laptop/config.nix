{
  lib,
  pkgs,
  config,
  osConfig,
  user,
  ...
}:
let
  args = {
    inherit config;
    inherit lib;
    inherit osConfig;
    inherit pkgs;
    inherit user;
  };
in
{
  mainBar = {
    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [
      "hyprland/workspaces"

      "cpu"
      "memory"
      "disk"
    ];

    modules-right = [
      "tray"

      "pulseaudio"
      "battery"
      "backlight"
      "network"
      "clock"
    ];

    "hyprland/workspaces" = (import ../../modules/hyprland/workspaces.nix args)."hyprland/workspaces";

    inherit ((import ../../modules/backlight.nix args)) backlight;
    inherit ((import ../../modules/battery.nix args)) battery;
    inherit ((import ../../modules/clock.nix args)) clock;
    inherit ((import ../../modules/cpu.nix args)) cpu;
    inherit ((import ../../modules/disk.nix args)) disk;
    inherit ((import ../../modules/memory.nix args)) memory;
    inherit ((import ../../modules/network.nix args)) network;
    inherit ((import ../../modules/pulseaudio.nix args)) pulseaudio;
    inherit ((import ../../modules/tray.nix args)) tray;
  };
}
