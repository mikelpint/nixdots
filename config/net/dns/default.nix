{ lib, pkgs, ... }:
{
  imports = [
    ./dnscrypt-proxy
    ./systemd-resolved
  ];

  networking = {
    nameservers = [
      "127.0.0.1"
      "::1"

      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];

    dhcpcd = {
      extraConfig = "nohook resolv.conf";
    };

    networkmanager = {
      dns = lib.mkOverride 75 "none";
    };
  };

  environment = {
    etc = {
      hosts = {
        mode = "0644";
      };
    };

    systemPackages = with pkgs; [ whois ];
  };
}
