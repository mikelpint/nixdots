{ pkgs, ... }:
let
  script = "hypr/scripts/launch_waybar";
in
{
  home = {
    packages = with pkgs; [
      (writeShellScriptBin "hyprsetup_bar" ''
        pkill waybar
        "$XDG_CONFIG_HOME"/"${script}" &
      '')
    ];
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_bar" ];
        };
      };
    };
  };

  xdg = {
    configFile = {
      "${script}" = {
        source = ../../extras/waybar/launch;
      };
    };
  };
}
