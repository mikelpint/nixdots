_: {
  imports = [
    ./hyprpaper/home.nix
    ./swww/home.nix
  ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          exec-once = [ "hyprsetup_wallpaper" ];
        };
      };
    };
  };
}
