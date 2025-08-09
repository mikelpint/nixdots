# https://esev.com/blog/post/2015-01-pgp-ssh-key-on-yubikey-neo/

{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
{
  home = {
    packages = with pkgs; [
      pinentry-gnome3
      # gnome-keysign
      gcr_4
      seahorse
    ];

    sessionVariables = lib.mkIf (config.services.ssh.enable or false) {
      SSH_AUTH_SOCK = "${
        config.home.sessionVariables.XDG_RUNTIME_DIR or "\${XDG_RUNTIME_DIR}"
      }/gnupg/S.gpg-agent.ssh";
    };
  };

  services = {
    gnome-keyring = {
      inherit (osConfig.services.gnome.gnome-keyring or { enable = false; }) enable;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    gpg-agent = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable or false;

      enableSshSupport = config.services.ssh.enable or false;
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

  programs = {
    gpg = {
      enable = true;
      package = pkgs.gnupg;

      scdaemonSettings = {
        disable-ccid = true;
      };

      publicKeys = [ { source = ./0xE9392D102A568F9A.asc; } ];
    };

    zed-editor = {
      extraPackages = lib.optionals (config.services.gnome-keyring.enable or false) (
        with pkgs; [ gnome-keyring ]
      );
    };
  };
}
