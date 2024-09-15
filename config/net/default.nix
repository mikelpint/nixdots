{ lib, ... }:
{
  imports = [
    ./dhcp
    ./dns
    ./firewall
    ./if
    ./ip
    ./mac
    ./nat
    ./networkmanager
    ./systemd-networkd
    ./vpn
    ./wpa_supplicant
  ];
}
