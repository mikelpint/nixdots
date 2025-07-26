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
      lib.optional
        ((config.services.mako.enable or false) && (osConfig.programs.hyprland.enable or false))
        (
          writeShellScriptBin "hyprsetup_notifications" ''
            hyprctl dismissnotify

            ${pkgs.procps}/bin/pkill mako
            ${config.services.mako.package or pkgs.mako}/bin/mako &
          ''
        );
  };

  services = {
    mako = {
      enable = true;
      package = pkgs.mako;

      settings = {
        default-timeout = 5000;
        ignore-timeout = 1;

        sort = "-time";
        layer = "overlay";

        border-size = 2;
        border-radius = 15;

        font = "JetBrainsMono Nerd Font 12";
        max-icon-size = 64;
      };
    };
  };

  catppuccin = {
    mako = {
      inherit (config.catppuccin) enable flavor accent;
    };
  };
}
