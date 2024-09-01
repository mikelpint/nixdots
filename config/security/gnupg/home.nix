{ pkgs, ... }:

{
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
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
