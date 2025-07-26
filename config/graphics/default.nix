{ pkgs, user, ... }:
{
  imports = [
    ./hidpi
    ./wayland
    ./x
    ./xdg
  ];

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "pink";
  };

  environment = {
    systemPackages = with pkgs; [
      ffmpeg
      SDL2
    ];
  };

  users = {
    users = {
      "${user}" = {
        extraGroups = [
          "render"
          "video"
        ];
      };
    };
  };
}
