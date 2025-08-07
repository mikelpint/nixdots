{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [ ../../../theme/swww/home.nix ];

  home =
    lib.mkIf
      (
        (config.systemd.user.services.swww.Service.enable or false)
        && (true || (config.systemd.user.services.wallpaper.Service.enable or false))
      )
      {
        packages =
          with pkgs;
          with inputs.swww.packages.${pkgs.system};
          [
            swww

            (writeShellScriptBin "hyprsetup_wallpaper" ''
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
