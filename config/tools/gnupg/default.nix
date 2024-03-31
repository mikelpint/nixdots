{ pkgs, ... }:

{
  services = {
    pcscd = {
      enable = true;
      programs = {
        gnupg = {
          agent = {
            enable = true;
            pinentryFlavor = "curses";
            enableSSHSupport = true;
          };
        };
      };
    };
  };

  home = {
    packages = with pkgs; [ pinentry pinentry-curses ];

    file.".local/share/gnupg/gpg-agent.conf".text =
      "pinentry-program /run/current-system/sw/bin/pinentry-curses";

    sessionVariables = { GNUPGHOME = "$XDG_DATA_HOME/gnupg"; };
  };
}
