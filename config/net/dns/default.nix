{ lib, ... }:
{
  imports = [ ./dnscrypt-proxy ];

  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    dhcpcd = {
      extraConfig = "nohook resolv.conf";
    };

    networkmanager = {
      dns = lib.mkOverride 75 "none";
    };
  };
}
