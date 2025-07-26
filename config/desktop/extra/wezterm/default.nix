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

  nix = {
    settings = {
      substituters = [ "https://wezterm.cachix.org" ];
      trusted-public-keys = [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
    };
  };
}
