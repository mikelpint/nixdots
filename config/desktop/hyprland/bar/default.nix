{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      [
        (writeShellScriptBin "hyprsetup_bar" ''
          pkill waybar
          waybar -c "$HOME"/.config/waybar/config -s "$HOME"/.config/waybar/style.css &
        '')
      ];
  };

  wayland = {
    windowManager = {
      hyprland = { settings = { exec-once = [ "hyprsetup_bar" ]; }; };
    };
  };
}
