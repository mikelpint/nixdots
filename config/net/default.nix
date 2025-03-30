_: {
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

  networking = {
    hosts = {
      # "127.0.0.1" = [ "dspace.deustotech.eu" ];
      # "10.0.0.50" = [ "dspace.deustotech.eu" ];
      # "10.201.0.1" = [ "dspace.deustotech.eu" ];
    };
  };
}
