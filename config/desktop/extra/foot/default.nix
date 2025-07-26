{ pkgs, ... }:
{
  xdg = {
    terminal-exec = {
      enable = true;
      package = pkgs.xdg-terminal-exec-mkhl;

      settings = {
        Hyprland = [
          "org.wezfurlong.wezterm.desktop"
          "xterm.desktop"
        ];
        GNOME = [
          "org.wezfurlong.wezterm.desktop"
          "xterm.desktop"
        ];
        DWL = [
          "org.wezfurlong.wezterm.desktop"
          "xterm.desktop"
        ];
        default = [
          "org.wezfurlong.wezterm.desktop"
          "xterm.desktop"
        ];
      };
    };
  };
}
