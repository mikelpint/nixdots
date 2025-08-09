{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../../theme/swww/home.nix ];

  home = {
    packages = lib.optional (config.systemd.user.services.swww.Service.enable or false) (
      pkgs.writeShellScriptBin "hyprsetup_wallpaper" ''
        systemctl restart --user swww
        systemctl restart --user wallpaper
      ''
    );
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
