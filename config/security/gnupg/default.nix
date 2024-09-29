{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      pinentry-gnome3
    ];
  };

  programs = {
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-curses;
      };
    };
  };

  services = {
    gnome = {
      gnome-keyring = {
        enable = true;
      };
    };
  };
}
