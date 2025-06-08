{
  pkgs,
  self,
  user,
  lib,
  ...
}:
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
    ./systemd-networkd
    ./tor
    ./vpn
    ./wpa_supplicant
  ];

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

  networking = lib.mkMerge [
    {
      hosts = { };
    }

    # (lib.mkIf (builtins.isString machineId) {
    #   hostId = builtins.substring 0 7 machineId;
    # })
  ];

  environment = {
    systemPackages = with pkgs; [
      bridge-utils
      ethtool
      inetutils
      traceroute
      mtr
    ];
  };

  security = {
    pki = {
      # certificateFiles = [ config.age.secrets."mikelpint.com.crt".path ];
    };
  };

  boot = {
    blacklistedKernelModules = [
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "n-hdlc"
      "ax25"
      "netrom"
      "x25"
      "rose"
      "decnet"
      "econet"
      "af_802154"
      "ipx"
      "appletalk"
      "psnap"
      "p8023"
      "p8022"
      "can"
      "atm"
    ];
  };
}
