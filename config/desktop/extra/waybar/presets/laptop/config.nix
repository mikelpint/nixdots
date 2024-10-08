_:

let
  "hyprland/workspaces" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";

  backlight = (import ../../modules/backlight.nix).backlight;
  battery = (import ../../modules/battery.nix).battery;
  clock = (import ../../modules/clock.nix).clock;
  cpu = (import ../../modules/cpu.nix).cpu;
  disk = (import ../../modules/disk.nix).disk;
  memory = (import ../../modules/memory.nix).memory;
  network = (import ../../modules/network.nix).network;
  pulseaudio = (import ../../modules/pulseaudio.nix).pulseaudio;
  tray = (import ../../modules/tray.nix).tray;
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

    inherit "hyprland/workspaces";

    inherit backlight;
    inherit battery;
    inherit clock;
    inherit cpu;
    inherit disk;
    inherit memory;
    inherit network;
    inherit pulseaudio;
    inherit tray;
  };
}
