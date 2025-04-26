{ pkgs, ... }:
{
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
    ./vpn
    ./wpa_supplicant
  ];

  networking = {
    hosts = { };
  };

  environment = {
    systemPackages = with pkgs; [ ethtool traceroute ];
  };
}
