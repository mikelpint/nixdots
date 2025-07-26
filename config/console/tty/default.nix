{ pkgs, config, ... }:
{
  imports = [
    ./securetty

    # ./1.nix
  ];

  boot = {
    kernel = {
      sysctl = {
        "dev.tty.ldisc_autoload" = "0";
      };
    };
  };

  services = {
    getty = {
      autologinUser = null;
      loginProgram = "${pkgs.shadow}/bin/login";
    };
  };

  catppuccin = {
    tty = {
      enable = true;
      inherit (config.catppuccin) flavor;
    };
  };
}
