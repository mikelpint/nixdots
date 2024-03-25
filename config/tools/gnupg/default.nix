{ pkgs, ... }:

{
  environment = { systemPackages = with pkgs; [ pinentry pinentry-curses ]; };

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
    file.".local/share/gnupg/gpg-agent.conf".text =
      "pinentry-program /run/current-system/sw/bin/pinentry-curses";
  };

  environment = { variables = { GNUPGHOME = "$XDG_DATA_HOME/gnupg"; }; };
}
