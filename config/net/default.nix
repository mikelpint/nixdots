{ lib, ... }:
{
  imports = [
    ./dns
    ./firewall
    ./nat
  ];

  networking = {
    networkmanager = {
      enable = true;
    };

    enableIPv6 = false;

    dhcpcd = {
      wait = "background";
      extraConfig = "noarp";
    };

    hostName = lib.mkDefault "mikel";
  };
}
