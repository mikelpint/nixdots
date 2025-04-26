{ pkgs, ... }:
{
  xdg = {
    terminal-exec = {
      enable = true;
      package = pkgs.xdg-terminal-exec-mkhl;

      settings = {
        Hyprland = [ "org.wezfurlong.wezterm.desktop" ];

        default = [ "org.wezfurlong.wezterm.desktop" ];
      };
    };
  };
}
