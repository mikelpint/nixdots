{
  config,
  inputs,
  pkgs,
  lib,
  self,
  ...
}:
{
  environment = {
    systemPackages = with pkgs; [
      inputs.agenix-rekey.packages."${pkgs.system}".default
      age-plugin-yubikey
      age-plugin-fido2-hmac
      age
      rage
    ];
  };

  age = {
    ageBin = "${pkgs.rage}/bin/rage";

    rekey = {
      masterIdentities = [
        {
          identity = "${self}/config/security/age/yubikey.pub";
          pubkey = "age1yubikey1qgx4wem5rcv65tn0atrn52pqcp9xa2t07hzf440zfyjeputnj7xzzh6xq9x";
        }
      ];

      storageMode = "local";
      localStorageDir = "${self}/secrets/rekeyed/${lib.strings.removeSuffix "mikel" config.networking.hostName}";
    };
  };
}
