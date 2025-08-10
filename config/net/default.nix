{
  pkgs,
  self,
  config,
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

  networking = {
    hosts = { };
  }
  # // (
  #   let
  #     machineId = lib.strings.trim (
  #       config.environment.etc.machine-id.text or (
  #         if
  #           builtins.isPath (config.environment.etc.machine-id.source or null)
  #           || builtins.isString (config.environment.etc.machine-id.source or null)
  #         then
  #           builtins.readFile config.environment.etc.machine-id.source
  #         else
  #           ""
  #       )
  #     );
  #   in
  #   lib.mkIf (builtins.isString machineId && builtins.stringLength machineId >= 0) {
  #     hostId = builtins.substring 0 7 (
  #       if (builtins.stringLength machineId) >= 8 then
  #         machineId
  #       else
  #         (builtins.hashString machineId "sha256")
  #     );
  #   }
  # )
  ;

  environment = {
    systemPackages = with pkgs; [
      bridge-utils
      iproute2
      ethtool
      inetutils
      mtr
      traceroute
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries =
        let
          binExists = pkg: bin: "${lib.getBin pkg}/bin/${bin}";

          find = lib.lists.findFirst (
            let
              inetutils = lib.getName pkgs.inetutils;
            in
            x: ((if lib.attrsets.isDerivation x then lib.getName x else null) == inetutils)
          );

          inetutils =
            find (find null config.environment.systemPackages)
              config.home-manager.users.${user}.home.packages;
        in
        lib.mkIf (inetutils != null) {
          ftp = lib.mkIf (binExists inetutils "ftp") {
            executable = "${lib.getBin inetutils}/bin/ftp";
            profile = "${pkgs.firejail}/etc/firejail/ftp.profile";
          };

          ping = lib.mkIf (binExists inetutils "ping") {
            executable = "${lib.getBin inetutils}/bin/ping";
            profile = "${pkgs.firejail}/etc/firejail/ping-hardedned.inc.profile";
          };

          ping6 = lib.mkIf (binExists inetutils "ping6") {
            executable = "${lib.getBin inetutils}/bin/ping";
            profile = "${pkgs.firejail}/etc/firejail/ping-hardedned.inc.profile";
          };

          whois = lib.mkIf (binExists inetutils "whois") {
            executable = "${lib.getBin inetutils}/bin/whois";
            profile = "${pkgs.firejail}/etc/firejail/whois.profile";
          };
        };
    };
  };

  security = {
    pki = {
      certificateFiles = [
        "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      ];
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

  users = {
    users = {
      "${user}" = {
        extraGroups = [
          "dialout"
          "netdev"
        ];
      };
    };
  };
}
