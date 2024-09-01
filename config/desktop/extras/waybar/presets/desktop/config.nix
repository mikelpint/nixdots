{
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  isamd = builtins.elem "amdgpu" osConfig.services.xserver.videoDrivers;

  "custom/gpu" = lib.mkMerge [
    (import ../../modules/custom/gpu.nix)."custom/gpu"
    {
      return-type = lib.mkForce "json";
      exec = lib.mkForce "waybar_gpu_json";
      on-click = lib.mkForce (if isamd then "wezterm -e amdgpu_top" else "wezterm -e nvtop");
      tooltip = true;
    }
  ];

  "hyprland/language" = (import ../../modules/hyprland/language.nix)."hyprland/language";
  "hyprland/workspaces" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";
  "hyprland/workspaces#other" = (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";

  clock = (import ../../modules/clock.nix).clock;
  "clock#other" = (import ../../modules/clock.nix).clock;
  cpu = lib.mkMerge [
    (import ../../modules/cpu.nix).cpu
    { interval = lib.mkForce 1; }
  ];
  disk = (import ../../modules/disk.nix).disk;
  keyboard-state = lib.mkMerge [
    (import ../../modules/keyboard-state.nix).keyboard-state
    { device-path = "/dev/input/event0"; }
  ];
  memory = lib.mkMerge [
    (import ../../modules/memory.nix).memory
    { interval = lib.mkForce 1; }
  ];
  network = lib.mkMerge [
    (import ../../modules/network.nix).network
    { interval = lib.mkForce 5; }
  ];
  pulseaudio = (import ../../modules/pulseaudio.nix).pulseaudio;
  "temperature#cpu" = lib.mkMerge [
    (import ../../modules/temperature.nix).temperature
    {
      hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input";
      format = lib.mkForce " {temperatureC}°C";
      interval = lib.mkForce 1;
      on-click = "wezterm -e btop";
    }
  ];
  "temperature#gpu1" = lib.mkMerge [
    (import ../../modules/temperature.nix).temperature
    {
      format = lib.mkForce " {temperatureC}°C";
      interval = lib.mkForce 1;
    }
  ];
  "temperature#gpu2" = lib.mkMerge [
    (import ../../modules/temperature.nix).temperature
    {
      hwmon-path = "/sys/devices/pci0000:00/0000:00:01.2/0000:02:00.0/0000:03:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.0/hwmon/hwmon5/temp2_input";
      format = lib.mkForce " {temperatureC}°C";
      interval = lib.mkForce 1;
      on-click = "wezterm -e amdgpu_top";
    }
  ];
  tray = (import ../../modules/tray.nix).tray;
in
{
  main = {
    output = if isamd then "DP-1" else "DVI-D-1";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [
      "hyprland/workspaces"

      "cpu"
      "custom/gpu"
      "memory"
      "disk"

      "temperature#cpu"
      # "temperature#gpu1"
      "temperature#gpu2"
    ];

    modules-right = [
      "keyboard-state"
      "hyprland/language"

      "tray"

      "pulseaudio"
      "network"
      "clock"
    ];

    inherit "custom/gpu";

    inherit "hyprland/language";
    inherit "hyprland/workspaces";

    inherit clock;
    inherit cpu;
    inherit disk;
    inherit keyboard-state;
    inherit memory;
    inherit network;
    inherit pulseaudio;
    inherit "temperature#cpu";
    # inherit "temperature#gpu1";
    inherit "temperature#gpu2";
    inherit tray;
  };

  other = {
    output = if isamd then "DP-2" else "DP-1";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [ "hyprland/workspaces#other" ];

    modules-right = [ "clock#other" ];

    inherit "hyprland/workspaces#other";

    inherit "clock#other";
  };
}
