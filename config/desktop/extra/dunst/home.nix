{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      (lib.optional
        ((config.services.dunst.enable or false) && (osConfig.programs.hyprland.enable or false))
        (
          writeShellScriptBin "hyprsetup_notifications" ''
            hyprctl dismissnotify

            ${pkgs.procps}/bin/pkill dunst
            ${config.services.dunst.package or pkgs.dunst}/bin/dunst &
          ''
        )
      );
  };

  services = {
    dunst = {
      enable = true;
    };
  };

  catppuccin = {
    dunst = {
      inherit (config.catppuccin) enable flavor;
    };
  };
}
