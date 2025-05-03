# https://esev.com/blog/post/2015-01-pgp-ssh-key-on-yubikey-neo/

{
  pkgs,
  osConfig,
  user,
  ...
}:
{
  home = {
    packages = with pkgs; [
      pinentry-gnome3
      gnome-keysign
      gcr
      seahorse
    ];

    sessionVariables = {
      SSH_AUTH_SOCK = "/run/user/${
        builtins.toString osConfig.users.users.${user}.uid
      }/gnupg/S.gpg-agent.ssh";
    };
  };

  services = {
    gnome-keyring = {
      inherit (osConfig.services.gnome.gnome-keyring) enable;
    };
  };

  programs = {
    gpg = {
      enable = true;

      scdaemonSettings = {
        disable-ccid = true;
      };

      publicKeys = [ { source = ./0xE9392D102A568F9A.asc; } ];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;

      enableSshSupport = true;
      sshKeys = [
        "0A27D9893F23EC7F56128C46AE1DA30AA366565C"
        "382A327A76281433DC412EB5004370EAF504EA0F"
      ];

      enableExtraSocket = true;

      pinentry = {
        package = pkgs.pinentry-curses;
      };

      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
}
