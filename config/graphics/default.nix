{ pkgs, ... }:
{
  imports = [
    ./hidpi
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
}
