{ lib, ... }:
{
  imports = [
    ./keyboard/home.nix
    ./mouse/home.nix
    ./touchpad/home.nix
  ];

  wayland = {
    windowManager = {
      hyprland = {
        settings = {
          input = {
            repeat_delay = lib.mkDefault 140;
            repeat_rate = lib.mkDefault 30;
          };
        };
      };
    };
  };
}
