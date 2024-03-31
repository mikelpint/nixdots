{ pkgs, ... }:

{
  services = { udev = { packages = with pkgs; [ yubikey-personalization ]; }; };

  home = { packages = with pkgs; [ yubioath-flutter ]; };
}
