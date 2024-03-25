{ lib, ... }:

let
  secret = lib.importTOML "../../../secrets/protonvpn/cert";
  ipport =
    "^((?:(?:d|[1-9]d|1dd|2[0-4]d|25[0-5])(?:.(?!:)|)){4}):(?!0)(d{1,4}|[1-5]d{4}|6[0-4]d{3}|65[0-4]d{2}|655[0-2]d|6553[0-5])$";
in {
  imports = [ ../../../modules/protonvpn.nix ];

  services = {
    protonvpn = {
      enable = true;
      autostart = true;

      interface = {
        name = "protonvpn";
        privateKeyFile = "../../../secrets/protonvpn/private";

        ip = secret.Interface.Address;
        dns = {
          enable = true;
          ip = secret.Interface.DNS;
        };
      };

      endpoint = {
        publicKey = secret.Endpoint.PublicKey;
        ip = builtins.elemAt (builtins.match ipport secret.Endpoint.EndPoint) 0;
        port =
          builtins.elemAt (builtins.match ipport secret.Endpoint.EndPoint) 1;
      };
    };
  };
}
