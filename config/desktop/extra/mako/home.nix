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

  xdg = {
    configFile = {
      "mako/config" = {
        text = ''
          background-color=#24273a
          text-color=#cad3f5
          border-color=#f5bde6
          progress-color=over #363a4f

          [urgency=high]
          border-color=#f5a97f
        '';
      };
    };
  };
}
