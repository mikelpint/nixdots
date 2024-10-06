# https://esev.com/blog/post/2015-01-pgp-ssh-key-on-yubikey-neo/

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      pinentry-gnome3
    ];

    sessionVariables = {
      GPG_AGENT_INFO = "/tmp/gpg-Z74lEJ/S.gpg-agent:25585:1";
      SSH_AUTH_SOCK = "/tmp/gpg-KS5kJr/S.gpg-agent.ssh";
      SSH_AGENT_PID = 25585;
    };
  };

  programs = {
    gpg = {
      enable = true;

      scdaemonSettings = {
        disable-ccid = true;
      };

      publicKeys = [
        {
          source = ./0xE9392D102A568F9A.asc;
        }
      ];
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

      pinentryPackage = pkgs.pinentry-curses;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };
}
