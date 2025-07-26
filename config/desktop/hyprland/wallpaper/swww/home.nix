{ pkgs, ... }:
{
  imports = [ ../../../theme/swww/home.nix ];

  home = {
    packages = [
      (pkgs.writeShellScriptBin "hyprsetup_wallpaper" ''
        systemctl restart --user swww
        systemctl restart --user wallpaper
      '')
    ];
  };

  systemd = {
    user = {
      services = {
        wallpaper = {
          Unit = {
            After = [ "hyprland-session.target" ];
          };

          Install = {
            WantedBy = [ "hyprland-session.target" ];
          };
        };
      };
    };
  };
}
