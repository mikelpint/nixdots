{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      mako

      (writeShellScriptBin "hyprsetup_notifications" ''
        hyprctl dismissnotify

        pkill mako
        mako &
      '')
    ];
  };

  catppuccin = {
    mako = {
      enable = true;
    };
  };

  xdg = {
    configFile = {
      "mako/config" = {
        text = ''
          default-timeout=5000
          ignore-timeout=1

          sort=-time
          layer=overlay

          border-size=2
          border-radius=15

          font=JetBrainsMono Nerd Font 12
          max-icon-size=64

          background-color=#24273a
          text-color=#cad3f5
          border-color=#f5bde6
          progress-color=over #363a4f

          [urgency=high]
          border-color=#f5a97f
          default-timeout=0
        '';
      };
    };
  };
}
