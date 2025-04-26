_:

let
  "hyprland/workspaces" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";

  inherit ((import ../../modules/backlight.nix)) backlight;
  inherit ((import ../../modules/battery.nix)) battery;
  inherit ((import ../../modules/clock.nix)) clock;
  inherit ((import ../../modules/cpu.nix)) cpu;
  inherit ((import ../../modules/disk.nix)) disk;
  inherit ((import ../../modules/memory.nix)) memory;
  inherit ((import ../../modules/network.nix)) network;
  inherit ((import ../../modules/pulseaudio.nix)) pulseaudio;
  inherit ((import ../../modules/tray.nix)) tray;
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
