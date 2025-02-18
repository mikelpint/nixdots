{ lib, pkgs, ... }: {
  environment = { systemPackages = with pkgs; [ sbctl ]; };

  boot = {
    loader = {
      grub = { enable = lib.mkForce false; };

      systemd-boot = { enable = lib.mkForce false; };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
