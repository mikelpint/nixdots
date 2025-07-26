{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
{
  wayland = lib.mkIf (builtins.elem "nvidia" osConfig.services.xserver.videoDrivers) {
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
        };
      };
    };
  };

  home =
    lib.mkIf
      ((builtins.elem "nvidia" osConfig.services.xserver.videoDrivers) && config.programs.waybar.enable)
      {
        packages = with pkgs; [
          (writeShellScriptBin "waybar_gpu_json" ''
            text=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
            tooltip=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)

            printf '{\"text\": "%s", \"tooltip\": "%s"}' "''${text}" "''${tooltip}"
          '')
        ];
      };
}
