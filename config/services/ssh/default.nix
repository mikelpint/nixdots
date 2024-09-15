{ lib, ... }:
{
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];

      startWhenNeeded = lib.mkDefault true;

      settings = {
        LogLevel = "VERBOSE";

        AllowUsers = null;
        PermitRootLogin = "no";

        PasswordAuthentication = false;
        pubKeyAuthentication = true;
        KbdInteractiveAuthentication = false;

        UseDns = true;
        X11Forwarding = false;

        KexAlgorithms = [
          "sntrup761x25519-sha512@openssh.com"
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
        ];
      };
    };
  };

  users = {
    users = {
      mikel = {
        openssh = {
          authorizedKeys = {
            keyFiles = [
              ../../../hosts/desktop/host.pub
              ../../../hosts/laptop/host.pub
            ];
          };
        };
      };
    };
  };
}
