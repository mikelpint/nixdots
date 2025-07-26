{ pkgs, lib, ... }:
{
  xdg = {
    terminal-exec = {
      enable = true;
      package = lib.mkDefault pkgs.xdg-terminal-exec-mkhl;

      settings = {
        Hyprland = lib.mkAfter [ "xterm.desktop" ];
        GNOME = lib.mkAfter [ "xterm.desktop" ];
        default = lib.mkAfter [ "xterm.desktop" ];
      };
    };
  };
}
