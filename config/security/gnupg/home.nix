{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pinentry-gnome3
    ];
  };

  programs = {
    gpg = {
      enable = true;

      scdaemonSettings = {
        disable-ccid = true;
      };
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
}
