{
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  ifnvidia = lib.mkIf (builtins.elem "nvidia" osConfig.services.xserver.videoDrivers);
in
{
  wayland = ifnvidia {
    windowManager = {
      hyprland = {
        settings = {
          envd = [
            "LIBVA_DRIVER_NAME,nvidia"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NVD_BACKEND,direct"
          ];

          cursor = {
            no_hardware_cursors = true;
            allow_dumb_copy = true;
          };

          opengl = {
            nvidia_anti_flicker = lib.mkForce true;
          };

          render = {
            explicit_sync = lib.mkForce false;
          };
        };
      };
    };
  };

  home = ifnvidia {
    packages = with pkgs; [
      (writeShellScriptBin "waybar_gpu_json" ''
        text=''$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
        tooltip=''$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)

        printf '{\"text\": "%s", \"tooltip\": "%s"}' "''${text}" "''${tooltip}"
      '')
    ];
  };
}
