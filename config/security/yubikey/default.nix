{ pkgs, ... }:

{
  services = { udev = { packages = with pkgs; [ yubikey-personalization ]; }; };

  enviroment = { systemPackages = with pkgs; [ yubioath-desktop ]; };
}
