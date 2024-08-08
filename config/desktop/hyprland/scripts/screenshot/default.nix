{ pkgs, ... }: {
  home = {
    packages = with pkgs;
      [ grimblast ] ++ (builtins.map (type:
        (pkgs.writeShellScriptBin "screenshot-${type}" ''
          grimblast copysave ${type} $XDG_PICTURES_DIR/screenshots/$(date +"%F_%H-%M-%S-%N").png
        '')) [ "area" "screen" "output" ]);
  };

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          bind = [
            ", Print, exec, screenshot-area"
            "SHIFT, Print, exec, screenshot-output"
            "CTRL SHIFT, Print, exec, screenshot-screen"
          ];
        };
      };
    };
  };
}
