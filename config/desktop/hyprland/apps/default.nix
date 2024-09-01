let
  opacity = "0.95";
in
{
  imports = [
    ./firefox
    ./spotify
    ./steam
    ./wezterm
    ./wofi
  ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          windowrulev2 = [
            "opacity ${opacity} ${opacity},class:^(thunar)$"
            "opacity ${opacity} ${opacity},class:^(nautilus)$"
            "opacity ${opacity} ${opacity},class:^(discord)$"
            "opacity ${opacity} ${opacity},class:^(st-256color)$"
            "float,class:^(pavucontrol)$"
            "float,class:^(file_progress)$"
            "float,class:^(confirm)$"
            "float,class:^(dialog)$"
            "float,class:^(download)$"
            "float,class:^(notification)$"
            "float,class:^(error)$"
            "float,class:^(confirmreset)$"
            "float,title:^(Open File)$"
            "float,title:^(branchdialog)$"
            "float,title:^(Confirm to replace files)$"
            "float,title:^(File Operation Progress)$"
            "float,title:^(mpv)$"
          ];
        };
      };
    };
  };
}
