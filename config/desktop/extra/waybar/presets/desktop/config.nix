{ lib, osConfig, ... }:

let
  isamd = builtins.elem "amdgpu" osConfig.services.xserver.videoDrivers;
  gpuClick = gpu:
    if isamd then "wezterm -e amdgpu_top --pci ${gpu}" else "wezterm -e nvtop";
in {
  main = {
    output = if isamd then "DP-1" else "DVI-D-1";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [
      "hyprland/workspaces"

      "cpu"
      "custom/gpu1"
      "custom/gpu2"
      "memory"
      "disk"

      "temperature#cpu"
      "temperature#gpu1"
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

    "custom/gpu1" = lib.mkMerge [
      (import ../../modules/custom/gpu.nix)."custom/gpu"
      {
        return-type = lib.mkForce "json";
        exec = lib.mkForce "waybar_gpu_json 0000:07:00.0";
        on-click = lib.mkForce (gpuClick "0000:07:00.0");
        tooltip = true;
      }
    ];

    "custom/gpu2" = lib.mkMerge [
      (import ../../modules/custom/gpu.nix)."custom/gpu"
      {
        return-type = lib.mkForce "json";
        exec = lib.mkForce "waybar_gpu_json 0000:0d:00.0";
        on-click = lib.mkForce (gpuClick "0000:0d:00.0");
        tooltip = true;
      }
    ];

    "hyprland/language" =
      (import ../../modules/hyprland/language.nix)."hyprland/language";
    "hyprland/workspaces" =
      (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";

    inherit ((import ../../modules/clock.nix)) clock;
    cpu = lib.mkMerge [
      (import ../../modules/cpu.nix).cpu
      { interval = lib.mkForce 1; }
    ];
    inherit ((import ../../modules/disk.nix)) disk;
    keyboard-state = lib.mkMerge [
      (import ../../modules/keyboard-state.nix).keyboard-state
      { device-path = "/dev/input/by-id/usb-Keychron_Keychron_Q2-event-kbd"; }
    ];
    memory = lib.mkMerge [
      (import ../../modules/memory.nix).memory
      { interval = lib.mkForce 1; }
    ];
    network = lib.mkMerge [
      (import ../../modules/network.nix).network
      { interval = lib.mkForce 5; }
    ];
    inherit ((import ../../modules/pulseaudio.nix)) pulseaudio;
    "temperature#cpu" = lib.mkMerge [
      (import ../../modules/temperature.nix).temperature
      {
        hwmon-path =
          "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon3/temp1_input";
        format = lib.mkForce " {temperatureC}°C";
        interval = lib.mkForce 1;
        on-click = "wezterm -e btop";
      }
    ];
    "temperature#gpu1" = lib.mkMerge [
      (import ../../modules/temperature.nix).temperature
      {
        hwmon-path =
          "/sys/devices/pci0000:00/0000:00:01.2/0000:02:00.0/0000:03:02.0/0000:05:00.0/0000:06:00.0/0000:07:00.0/hwmon/hwmon2/temp1_input";
        format = lib.mkForce " {temperatureC}°C";
        interval = lib.mkForce 1;
        on-click = lib.mkForce (gpuClick "0000:07:00.0");
      }
    ];
    "temperature#gpu2" = lib.mkMerge [
      (import ../../modules/temperature.nix).temperature
      {
        hwmon-path =
          "/sys/devices/pci0000:00/0000:00:03.1/0000:0d:00.0/hwmon/hwmon3/temp1_input";
        format = lib.mkForce " {temperatureC}°C";
        interval = lib.mkForce 1;
        on-click = lib.mkForce (gpuClick "0000:0d:00.0");
      }
    ];
    inherit ((import ../../modules/tray.nix)) tray;
  };

  other = {
    output = if isamd then "DP-2" else "DP-1";

    layer = "top";
    position = "top";
    mod = "dock";

    modules-left = [ "hyprland/workspaces#other" ];
    modules-right = [ "clock#other" ];

    "hyprland/workspaces#other" =
      (import ../../modules/hyprland/workspaces.nix)."hyprland/workspaces";
    "clock#other" = (import ../../modules/clock.nix).clock;
  };
}
