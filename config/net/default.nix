{
  pkgs,
  self,
  user,
  ...
}:
{
  age = {
    secrets = {
      "mikelpint.com.crt" = {
        owner = user;
        rekeyFile = "${self}/secrets/mikelpint.com.crt.age";
      };

      "mikelpint.com.key" = {
        owner = user;
        rekeyFile = "${self}/secrets/mikelpint.com.key.age";
      };
    };
  };

  imports = [
    ./dhcp
    ./dns
    ./firewall
    ./if
    ./ip
    ./iwd
    ./mac
    ./nat
    ./networkmanager
    ./ntp
    ./systemd-networkd
    ./tor
    ./vpn
    ./wpa_supplicant
  ];

  networking = {
    hosts = { };
  };

  environment = {
    systemPackages = with pkgs; [
      bridge-utils
      ethtool
      inetutils
      traceroute
    ];
  };

  security = {
    pki = {
      # certificateFiles = [ config.age.secrets."mikelpint.com.crt".path ];
    };
  };
}
