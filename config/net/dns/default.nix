{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  imports = [
    ./dnscrypt-proxy
    ./systemd-resolved
  ];

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"

      "127.0.0.1"
    ]
    ++ (if config.networking.enableIPv6 then [ "::1" ] else [ ]);

    dhcpcd = {
      extraConfig = "nohook resolv.conf";
    };

    networkmanager = {
      dns = lib.mkOverride 75 "none";

      insertNameservers = config.networking.nameservers;
    };

    resolvconf = {
      enable = !config.services.resolved.enable;
      useLocalResolver = true;
    };
  };

  system = {
    nssDatabases = {
      hosts = lib.mkMerge [
        (lib.mkBefore [ "mdns_minimal [NOTFOUND=return]" ])
        (lib.mkAfter [ "mdns" ])
      ];
    };
  };

  environment = {
    etc = {
      hosts = {
        mode = "0644";
      };
    };

    systemPackages = with pkgs; [
      dig
      doggo
    ];
  };

  programs = {
    firejail = {
      wrappedBinaries = {
        dig =
          let
            find = lib.lists.findFirst (
              let
                dig = lib.getName pkgs.dig;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == dig)
              && (builtins.pathExists "${lib.getBin x}/bin/dig")
            );

            dig =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (dig != null) {
            executable = "${lib.getBin dig}/bin/dig";
            profile = "${pkgs.firejail}/etc/firejail/dig.profile";
          };

        doggo =
          let
            find = lib.lists.findFirst (
              let
                doggo = lib.getName pkgs.doggo;
              in
              x:
              ((if lib.attrsets.isDerivation x then lib.getName x else null) == doggo)
              && (builtins.pathExists "${lib.getBin x}/bin/doggo")
            );

            doggo =
              find (find null config.environment.systemPackages)
                config.home-manager.users.${user}.home.packages;
          in
          lib.mkIf (doggo != null) {
            executable = "${lib.getBin doggo}/bin/doggo";
            profile = "${pkgs.firejail}/etc/firejail/dig.profile";
          };
      };
    };
  };
}
