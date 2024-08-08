{ lib, ... }:

let
  "custom/launcher" = (import ../../modules/custom/launcher.nix)."custom/launcher";
  "custom/powermenu" = (import ../../modules/custom/powermenu.nix)."custom/powermenu";

  "hyprland/language" = (import ../../modules/hyprland/language.nix)."hyprland/language";
  "hyprland/workspaces#other" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";
  "hyprland/workspaces" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";

  clock = (import ../../modules/clock.nix).clock;
  "clock#other" = (import ../../modules/clock.nix).clock;
  cpu = (import ../../modules/cpu.nix).cpu;
  disk = (import ../../modules/disk.nix).disk;
  keyboard-state = lib.mkMerge [
    (import ../../modules/keyboard-state.nix).keyboard-state
    { device-path = "/dev/input/event0"; }
  ];
  memory = (import ../../modules/memory.nix).memory;
  network = (import ../../modules/network.nix).network;
  pulseaudio = (import ../../modules/pulseaudio.nix).pulseaudio;
  tray = (import ../../modules/tray.nix).tray;
in
{
  main = {
    output = "DP-1";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [
      "custom/launcher"

      "hyprland/workspaces"

      "cpu"
      "memory"
      "disk"
    ];

    modules-right = [
      "keyboard-state"
      "hyprland/language"

      "tray"

      "pulseaudio"
      "network"
      "clock"
    ];

    inherit "custom/launcher";
    inherit "custom/powermenu";

    inherit "hyprland/language";
    inherit "hyprland/workspaces";

    inherit clock;
    inherit cpu;
    inherit disk;
    inherit keyboard-state;
    inherit memory;
    inherit network;
    inherit pulseaudio;
    inherit tray;
  };

  other = {
    output = "DP-2";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [ "hyprland/workspaces#other" ];

    modules-right = [ "clock#other" ];

    inherit "hyprland/workspaces#other";

    inherit "clock#other";
  };
}
