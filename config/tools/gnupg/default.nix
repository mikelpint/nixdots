{ pkgs, ... }:

{
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };

  home = {
    packages = with pkgs; [ pinentry pinentry-curses ];

    file.".local/share/gnupg/gpg-agent.conf".text =
      "pinentry-program /run/current-system/sw/bin/pinentry-curses";

    sessionVariables = { GNUPGHOME = "$XDG_DATA_HOME/gnupg"; };
  };
}
