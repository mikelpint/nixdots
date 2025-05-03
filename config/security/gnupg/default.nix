{
  pkgs,
  config,
  ...
}:

{
  environment = {
    systemPackages = with pkgs; [ pinentry-gnome3 ];
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

  security = {
    pam = {
      services = {
        gnome-keyring = {
          inherit (config.services.gnome.gnome-keyring) enable;
          text = ''
            auth     optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
            session  optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start

            password  optional   ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
          '';
        };
      };
    };
  };
}
