# https://blog.stribik.technology/2015/01/04/secure-secure-shell.html

{
  self,
  user,
  lib,
  pkgs,
  config,
  ...
}:
let
  hosts = [
    "desktop"
    "laptop"
  ];

  port = 22;
in
{
  services = {
    openssh = lib.mkMerge [
      {
        enable = true;
        startWhenNeeded = lib.mkDefault false;
        package = lib.mkDefault pkgs.openssh;

        settings = {
          LogLevel = "VERBOSE";

          AllowUsers = lib.mkDefault [ user ];
          PermitRootLogin = "no";

          PasswordAuthentication = false;
          ChallengeResponseAuthentication = false;
          PubKeyAuthentication = true;
          KbdInteractiveAuthentication = false;

          UseDns = true;
          X11Forwarding = false;

          Ciphers = [
            "chacha20-poly1305@openssh.com"
            "aes256-gcm@openssh.com"
            "aes128-gcm@openssh.com"
            "aes256-ctr"
            "aes192-ctr"
            "aes128-ctr"
          ];

          KexAlgorithms = [
            "sntrup761x25519-sha512@openssh.com"
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
            "diffie-hellman-group-exchange-sha256"
          ];

          Macs = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
            "umac-128-etm@openssh.com"
            "hmac-sha2-512,hmac-sha2-256"
            "umac-128@openssh.com"
          ];

          StrictModes = true;
        };

        knownHosts = lib.listToAttrs (
          builtins.map (name: {
            inherit name;
            value = {
              publicKeyFile = "${self}/hosts/${name}/host.pub";
            };
          }) hosts
        );
      }

      (lib.mkIf (!(config.services.tor.enable && config.services.tor.relay.enable)) {
        ports = lib.mkDefault [ port ];
        openFirewall = lib.mkDefault true;
      })

      (lib.mkIf (config.services.tor.enable && config.services.tor.relay.enable) {
        listenAddresses = [
          {
            addr = "127.0.0.1";
            inherit port;
          }
        ];
      })
    ];
  };

  programs = {
    ssh = {
      hostKeyAlgorithms = [
        "ssh-ed25519-cert-v01@openssh.com"
        "ssh-rsa-cert-v01@openssh.com"
        "ssh-ed25519"
        "ssh-rsa"
      ];

      extraConfig = ''
        Host *
          UseRoaming no
      '';
    };
  };

  users = {
    users = {
      "${user}" = {
        openssh = {
          authorizedKeys = {
            keyFiles = builtins.map (host: "${self}/hosts/${host}/host.pub") hosts;
          };
        };
      };
    };
  };

  services = {
    tor = {
      relay = {
        onionServices = {
          ssh = {
            version = 3;
            # path = "/var/lib/tor/hidden_service/ssh";
            map = builtins.map (listenAddress: {
              inherit port;
              target = { inherit (listenAddress) addr port; };
            }) config.services.openssh.listenAddresses;
          };
        };
      };
    };
  };
}
